var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

iapp.MapGet("/", () => "Hello, World5-ntech-devops class!");

app.Run("http://0.0.0.0:80");

