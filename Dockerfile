##############################################
# 1) BUILD & TEST STAGE
##############################################
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1.A) Copy nuget.config so restore can fetch xUnit & ASP.NET Core
COPY nuget.config .

# 1.B) Copy solution and project files
COPY HelloWorldDemo.sln .
COPY src/HelloWorld/HelloWorld.csproj    src/HelloWorld/
COPY tests/HelloWorld.Tests/HelloWorld.Tests.csproj tests/HelloWorld.Tests/

# 2) Restore all packages from nuget.org
RUN dotnet restore HelloWorldDemo.sln

# 3) Copy the rest of your source code
COPY . .

# 4) Build the entire solution
RUN dotnet build HelloWorldDemo.sln \
    --configuration Release

# 5) Run unit tests (will fail the build if tests fail)
RUN dotnet test tests/HelloWorld.Tests/HelloWorld.Tests.csproj \
    --configuration Release \
    --no-build \
    --logger "trx;LogFileName=test_results.trx"

# 6) Publish only the web app into /app/publish
RUN dotnet publish src/HelloWorld/HelloWorld.csproj \
    --configuration Release \
    --no-build \
    --output /app/publish

##############################################
# 2) RUNTIME STAGE
##############################################
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# 7) Copy published output from the build stage
COPY --from=build /app/publish .

# 8) Configure to listen on port 80
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80

# 9) Launch the app
ENTRYPOINT ["dotnet", "HelloWorld.dll"]

