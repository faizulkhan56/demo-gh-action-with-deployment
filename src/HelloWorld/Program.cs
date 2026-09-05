var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello, World-ntech1-devops class-test!");

app.Run("http://0.0.0.0:80");

