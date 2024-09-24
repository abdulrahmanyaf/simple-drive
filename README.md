# Simple Drive

**Simple Drive** is a Ruby on Rails-based system that provides a unified interface for users to upload and retrieve data blobs. The system is fully configurable, allowing administrators to select the storage backend that best suits their business requirements. The following storage backends are currently supported:

1. **Amazon S3 Compatible Storage Service**
2. **Database**
3. **Local File System**
4. **FTP**

The system's architecture is designed to be extensible, making it easy to integrate additional storage backends as needed.

## System Configuration

Several environment variables must be configured based on the storage backend you're using to ensure the system operates correctly:

- **`ACTIVE_STORAGE_BACKEND`**: Specifies the storage backend. Acceptable values: `aws`, `local`, `database`, `ftp`.
- **`AWS_ACCESS_KEY_ID`**: Your AWS access key for S3 storage.
- **`AWS_SECRET_ACCESS_KEY`**: Your AWS secret access key for S3 storage.
- **`AWS_REGION`**: The AWS region where your S3 storage is hosted.
- **`AWS_SERVICE_API_URL`**: The API URL for the S3-compatible storage service.
- **`LOCAL_STORAGE_DIR`**: The directory path for local storage.
- **`FTP_HOST`**: The FTP server host.
- **`FTP_PORT`**: The FTP server port.
- **`FTP_USER`**: The FTP server user.
- **`FTP_PASSWORD`**: The FTP server password.
- **`FTP_STORAGE_DIR`**: The directory path for remote FTP server storage.

Additionally, ensure that the **`devise_jwt_secret_key`** is set in your credentials to enable proper authentication.

## How to Use

To get started with Simple Drive, follow the steps below:

1. Install the required gems by running:

   ```bash
   bundle install
   ```

2. Run the database migrations:

   ```bash
   rails db:migrate
   ```

3. Start the Rails server:

   ```bash
   rails s
   ```

4. Create a user by sending a `POST` request to the **signup** endpoint:

   ```http
   POST http://127.0.0.1:3000/signup
   ```

   Example request body:

   ```json
   {
     "user": {
       "email": "test@gmail.com",
       "password": "123456"
     }
   }
   ```

5. Obtain an access token by logging in via the **login** endpoint:

   ```http
   POST http://127.0.0.1:3000/login
   ```

   Example request body:

   ```json
   {
     "user": {
       "email": "test@gmail.com",
       "password": "123456"
     }
   }
   ```

6. Upload a data blob using the **blobs_create** endpoint:

   ```http
   POST http://127.0.0.1:3000/v1/blobs
   ```

   Example request body:

   ```json
   {
     "id": "test",
     "data": "SGVsbG8gU2ltcGxlIFN0b3JhZ2UgV29ybGQh"
   }
   ```

7. Retrieve a data blob using the **blobs_show** endpoint, where `test` is the ID used during the upload:

   ```http
   GET http://127.0.0.1:3000/v1/blobs/test
   ```

## Extensibility

Simple Drive is designed for flexibility, allowing for seamless integration of additional storage backends if your business requirements change. Contributions and enhancements are welcome to further expand its capabilities.
