import 'dart:convert';
import 'dart:io';

void main() async
{
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print("Server running on port 8080. ");

  await for(var request in server)
    {
      switch(request.method)
      {

        case('GET'):
          handleGetRequest(request);
          break;
        case('POST'):
          handlePostRequest(request);
          break;
        default:
          request.response.statusCode = HttpStatus.methodNotAllowed;
          request.response.write('Unsupported request method: ${request.method}');
          await request.response.close();
          break;

      }
    }
}

void handleGetRequest(HttpRequest request) async
{

  final String filePath = request.uri.path == '/' ? 'index.html' : '${request.uri.path}';
  final File file = File(filePath);

    if (await file.exists()) {
      request.response.headers.contentType = ContentType.html;
      await request.response.addStream(file.openRead());
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('404 Not Found');
    }
    await request.response.close();
}

void handlePostRequest(HttpRequest request) async
{
  final body = await utf8.decodeStream(request);
  request.response.write('Recieved POST request with body: $body');
  await request.response.close;
}
