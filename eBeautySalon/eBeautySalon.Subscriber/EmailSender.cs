using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Org.BouncyCastle.Tls;
using System.Text.RegularExpressions;
using static System.Net.Mime.MediaTypeNames;

namespace eBeautySalon.Subscriber
{
    public static class EmailSender
    {
        public static string ExtractFromMessage(string message, string wordToFind)
        {
            var index = 0;
            var words = message.Split('_');
            for (int i = 0; i < words.Length; i++)
            {
                //var temp = words[i];
                if (string.Equals(words[i], wordToFind))
                {
                    index = i + 1;
                    break;
                }       
            }
            return words[index];
        }
        public static void SendEmail(string emailTo, string message)
        {
            try
            {
                int smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "");
                string smtpServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "";
                string fromEmail = Environment.GetEnvironmentVariable("SMTP_USER") ?? "";
                string password = Environment.GetEnvironmentVariable("SMTP_PASS") ?? "";
                bool enableSSL = bool.TryParse(Environment.GetEnvironmentVariable("SMTP_SSL"), out bool result) ? result : true;
                bool defaultCredentials = bool.TryParse(Environment.GetEnvironmentVariable("SMTP_DEFAULT_CREDENTIALS"), out bool result2) ? result2 : false;

                Console.WriteLine($"EMAIL: {fromEmail}");

                // Set up the mail message
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(fromEmail);
                mail.To.Add(emailTo);
                mail.Subject = "Potvrda o rezervaciji";
                mail.Body = message;

                // Set up the SMTP client
                SmtpClient smtpClient = new SmtpClient()
                {
                    Host = smtpServer,
                    Port = smtpPort,
                    UseDefaultCredentials = defaultCredentials,
                    EnableSsl = enableSSL,
                    Credentials = new System.Net.NetworkCredential(fromEmail, password)
                };
               
                // Send the email
                if (emailTo != null && message != null)
                    smtpClient.Send(mail);

                Console.WriteLine("Email sent successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Failed to send email. Error: {ex.Message}");
            }
        }
    }
}
