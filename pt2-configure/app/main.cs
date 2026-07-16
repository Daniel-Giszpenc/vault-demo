using System; 

class Geeks {         
    static void Main(string[] args) { 
    string? apiToken = Environment.GetEnvironmentVariable("API_TOKEN");

    if (string.IsNullOrEmpty(apiToken))
    {
        Console.WriteLine("Error: API_TOKEN environment variable is not set.");
        return;
    }

        Console.WriteLine("The dependancy API token I need is: " + apiToken); 
    } 
}