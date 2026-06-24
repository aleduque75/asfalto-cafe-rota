import { createServerFn } from "@tanstack/react-start";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

export const generateUploadUrl = createServerFn({ method: "POST" })
  .validator((data: { filename: string; contentType: string }) => data)
  .handler(async ({ data }) => {
    const { filename, contentType } = data;

    const region = process.env.AWS_REGION;
    const bucket = process.env.AWS_BUCKET_NAME;
    const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
    const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;

    if (!region || !bucket || !accessKeyId || !secretAccessKey) {
      throw new Error("Configurações da AWS ausentes no servidor.");
    }

    const s3Client = new S3Client({
      region,
      credentials: {
        accessKeyId,
        secretAccessKey,
      },
    });

    const uniqueId = crypto.randomUUID();
    // Use the motoclube folder as requested
    const key = `motoclube/${uniqueId}-${filename}`;

    const command = new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      ContentType: contentType,
    });

    // URL is valid for 5 minutes
    const presignedUrl = await getSignedUrl(s3Client, command, { expiresIn: 300 });
    
    // AWS S3 standard URL format
    const publicUrl = `https://${bucket}.s3.${region}.amazonaws.com/${key}`;

    return { presignedUrl, publicUrl, key };
  });
