using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using eBeautySalon.Subscriber;

var factory = new ConnectionFactory { HostName = "localhost" };
using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

channel.QueueDeclare(queue: "reservation_created",
                     durable: false,
                     exclusive: false,
                     autoDelete: false,
                     arguments: null);

Console.WriteLine(" [*] Waiting for messages.");

var consumer = new EventingBasicConsumer(channel);

consumer.Received += (model, ea) =>
{
    var body = ea.Body.ToArray();
    var message = Encoding.UTF8.GetString(body);
    Console.WriteLine($" [x] Received {message}");
    var extractedEmail = EmailSender.ExtractFromMessage(message,"email");
    var extractedUsluga = EmailSender.ExtractFromMessage(message, "usluga");
    var extractedDatum = EmailSender.ExtractFromMessage(message, "datum");
    var extractedTermin = EmailSender.ExtractFromMessage(message, "termin");
    EmailSender.SendEmail(extractedEmail, $"Uspjesno ste kreirali rezervaciju za uslugu '{extractedUsluga}' " +
        $"na datum {extractedDatum} u terminu od {extractedTermin}h. Vidimo se!");
};

channel.BasicConsume(queue: "reservation_created",
                     autoAck: true,
                     consumer: consumer);

Console.WriteLine(" Press [enter] to exit.");
Console.ReadLine();