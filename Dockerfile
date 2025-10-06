# Use official .NET runtime for running the app
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# Build stage with SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the .csproj file and restore dependencies
COPY Stylu/Stylu.csproj Stylu/
RUN dotnet restore "Stylu/Stylu.csproj"

# Copy the rest of the project files and build
COPY Stylu/ Stylu/
WORKDIR /src/Stylu
RUN dotnet publish -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Stylu.dll"]