using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System.Text;
using eBeautySalon.Subscriber;


public class Program
{
    public static void Main(string[] args)
    {
        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USER") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASS") ?? "guest",
            RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
            RequestedHeartbeat = TimeSpan.FromSeconds(60),
            AutomaticRecoveryEnabled = true,
            NetworkRecoveryInterval = TimeSpan.FromSeconds(10),
        };

        factory.ClientProvidedName = "Rabbit Test Consumer";

        try
        {
            Console.WriteLine($"Connecting to RabbitMQ at {factory.HostName}:{factory.Port} with user {factory.UserName}");
            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "reservation_created",
                                 durable: true,
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
                var extractedEmail = EmailSender.ExtractFromMessage(message, "email");
                var extractedUsluga = EmailSender.ExtractFromMessage(message, "usluga");
                var extractedDatum = EmailSender.ExtractFromMessage(message, "datum");
                var extractedTermin = EmailSender.ExtractFromMessage(message, "termin");
                EmailSender.SendEmail(extractedEmail, $"Uspjesno ste kreirali rezervaciju za uslugu '{extractedUsluga}' " +
                    $"na datum {extractedDatum} u terminu od {extractedTermin}h. Vidimo se!");

                // Acknowledge message
                channel.BasicAck(deliveryTag: ea.DeliveryTag, multiple: false);

                Console.WriteLine($" [*] Email sent: {extractedEmail}");
            };

            channel.BasicConsume(queue: "reservation_created",
                                 autoAck: false,
                                 consumer: consumer);

            Console.WriteLine(" Press [enter] to exit.");
            Console.ReadLine();

            // Sleep for a long time to keep the application running
            Thread.Sleep(Timeout.Infinite);

            // Close resources before exiting
            channel.Close();
            connection.Close();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Connection to RabbitMQ failed: {ex.Message}");
            Console.WriteLine(ex.ToString());
        }
    }
}

