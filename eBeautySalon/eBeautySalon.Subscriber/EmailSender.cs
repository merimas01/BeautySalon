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
                // Set up the mail message
                MailMessage mail = new MailMessage();
                mail.From = new MailAddress("servicebeautysalon@gmail.com");
                mail.To.Add(emailTo);
                mail.Subject = "Potvrda o rezervaciji";
                mail.Body = message;

                // Set up the SMTP client
                SmtpClient smtpClient = new SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    UseDefaultCredentials = false,
                    EnableSsl = true,
                    Credentials = new System.Net.NetworkCredential("servicebeautysalon@gmail.com", "duey ooom ouni lqqa")
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
