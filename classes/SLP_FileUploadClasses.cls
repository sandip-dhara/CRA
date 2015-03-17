public class SLP_FileUploadClasses
{
    public class FileRequest
    {
        public string Name { get; set; }
        public string DocId { get; set; }
        public string MimeType { get; set; }
        public string Base64Data { get; set; }
    }

    public class FileResponse
    {
        public string Name { get; set; }
        public string DocId { get; set; }
        public string InternalUrl { get; set; }
        public string ExternalUrl { get; set; }
        public boolean Success { get; set; }
        public string Error { get; set; }
        public string MimeType { get; set; }    
        public string Version { get; set; }  
    }


}