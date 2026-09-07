import nodemailer from 'nodemailer';

import { env } from '../utils/env.js';
import { logger } from '../utils/logger.js';

function allowDevFallback() {
  return env.nodeEnv !== 'production';
}

function hasSmtpConfig() {
  return Boolean(env.smtpHost && env.emailFrom);
}

function buildTransportOptions(port, secure) {
  return {
    host: env.smtpHost,
    port,
    secure,
    requireTLS: !secure,
    // shorter timeouts to avoid long blocking on hosted platforms
    connectionTimeout: Number.isFinite(env.smtpConnectionTimeout) ? env.smtpConnectionTimeout : 20000,
    greetingTimeout: Number.isFinite(env.smtpGreetingTimeout) ? env.smtpGreetingTimeout : 20000,
    socketTimeout: Number.isFinite(env.smtpSocketTimeout) ? env.smtpSocketTimeout : 20000,
    tls: {
      minVersion: 'TLSv1.2',
      rejectUnauthorized: false,
    },
    auth: env.smtpUser && env.smtpPassword
      ? {
          user: env.smtpUser,
          pass: env.smtpPassword,
        }
      : undefined,
  };
}

function createTransportCandidates() {
  if (!hasSmtpConfig()) {
    return [];
  }

  const preferredPort = Number.isFinite(env.smtpPort) ? env.smtpPort : 587;
  const candidates = [
    buildTransportOptions(preferredPort, preferredPort === 465),
  ];

  if (preferredPort !== 465) {
    candidates.push(buildTransportOptions(465, true));
  }

  if (preferredPort !== 587) {
    candidates.push(buildTransportOptions(587, false));
  }

  return candidates;
}

async function sendViaBrevo(email, subject, text, html) {
  if (!env.brevoApiKey) return null;
  
  const senderEmail = env.emailFrom || 'heis.adityasinha@gmail.com';
  const senderName = env.emailFromName || 'Blushy';
  
  logger.info(`Attempting email delivery via Brevo API to ${email}`);
  
  const response = await fetch('https://api.brevo.com/v3/smtp/email', {
    method: 'POST',
    headers: {
      'api-key': env.brevoApiKey,
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: JSON.stringify({
      sender: { name: senderName, email: senderEmail },
      to: [{ email }],
      subject,
      textContent: text,
      htmlContent: html,
    }),
  });

  const data = await response.json();
  if (response.ok) {
    logger.info(`Email successfully delivered via Brevo API to ${email}`, data);
    return { success: true, mode: 'brevo-api', data };
  } else {
    logger.warn(`Brevo API returned error (${response.status})`, data);
    throw new Error(`Brevo API error: ${JSON.stringify(data)}`);
  }
}

async function sendVerificationLink(email, verificationLink, code = null) {
  const subject = code ? `Your Blushy Verification Code: ${code}` : 'Verify your Blushy email';
  const text = [
    code ? `Your 6-digit verification code is: ${code}` : '',
    '',
    'Or click the link below to verify your email:',
    verificationLink ?? '',
    '',
    'This code/link expires in 10 minutes.',
  ].filter(Boolean).join('\n');

  const html = `
    <div style="font-family:Arial,sans-serif;line-height:1.5;color:#2b2b2b;max-width:500px;margin:0 auto;padding:20px;border:1px solid #f5d6de;border-radius:12px;background-color:#fff7f9;">
      <h2 style="margin:0 0 12px;color:#f76b8a;text-align:center;">Welcome to Blushy 🌸</h2>
      ${code ? `
      <p style="text-align:center;font-size:15px;color:#555;">Use the following 6-digit verification code to complete your signup:</p>
      <div style="text-align:center;margin:20px 0;">
        <span style="display:inline-block;font-size:32px;font-weight:bold;letter-spacing:6px;color:#f76b8a;background:#fff;padding:12px 24px;border-radius:8px;border:2px dashed #f76b8a;">${code}</span>
      </div>
      ` : ''}
      <p style="text-align:center;margin-top:16px;">Or click the button below to verify your account in your browser:</p>
      ${verificationLink ? `
      <div style="text-align:center;margin:16px 0;">
        <a href="${verificationLink}" style="display:inline-block;background-color:#f76b8a;color:#ffffff;text-decoration:none;padding:12px 28px;border-radius:24px;font-weight:bold;font-size:15px;">Verify Account</a>
      </div>
      <p style="margin-top:12px;font-size:12px;color:#888;word-break:break-all;text-align:center;"><a href="${verificationLink}" style="color:#f76b8a">${verificationLink}</a></p>
      ` : ''}
      <p style="margin-top:20px;font-size:12px;color:#888;text-align:center;">This verification code and link will expire in 10 minutes.</p>
    </div>
  `;

  // Always log clearly to console in dev mode so developer is never blocked
  if (allowDevFallback()) {
    console.log(`\n==================================================`);
    console.log(`🌸 [AUTH OTP DISPATCHED] Email: ${email}`);
    if (code) console.log(`🔑 6-DIGIT OTP CODE: ${code}`);
    if (verificationLink) console.log(`🔗 Link: ${verificationLink}`);
    console.log(`==================================================\n`);
  }

  // 1. Try Brevo API first (most reliable, high deliverability to temp mail & regular inboxes)
  if (env.brevoApiKey) {
    try {
      return await sendViaBrevo(email, subject, text, html);
    } catch (brevoErr) {
      logger.warn('Brevo API delivery failed, trying fallback transports...', brevoErr);
    }
  }

  // 2. Try SMTP candidates
  const transportCandidates = createTransportCandidates();
  if (transportCandidates.length > 0) {
    let lastError = null;
    for (const options of transportCandidates) {
      const transport = nodemailer.createTransport(options);
      logger.info(`Attempting SMTP send using ${options.host}:${options.port} secure=${options.secure}`);

      const timeoutMs = Number.isFinite(env.smtpAttemptTimeout) ? env.smtpAttemptTimeout : 20000;
      const timeoutPromise = new Promise((_, reject) => setTimeout(() => reject(new Error('SMTP attempt timed out')), timeoutMs));

      try {
        await Promise.race([
          transport.sendMail({
            from: env.emailFrom,
            to: email,
            subject,
            text,
            html,
          }),
          timeoutPromise,
        ]);

        logger.info(`SMTP send succeeded using ${options.host}:${options.port}`);
        return { success: true, transport: { host: options.host, port: options.port, secure: options.secure } };
      } catch (error) {
        lastError = error;
        logger.warn(`SMTP send failed using ${options.host}:${options.port} secure=${options.secure}`, error);
      } finally {
        try {
          transport.close();
        } catch (_) {
          // ignore
        }
      }
    }
  }

  // 3. Fallback for Dev
  if (allowDevFallback()) {
    return { success: true, mode: 'dev-fallback', code };
  }

  throw new Error('All email delivery methods failed. Check Brevo API or SMTP configuration.');
}

export const emailService = {
  hasSmtpConfig,
  sendVerificationLink,
};