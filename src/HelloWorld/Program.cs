var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello, World5-ntech-devops class-test!");

app.Run("http://0.0.0.0:80");

