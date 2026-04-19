# ParkMate AWS Deployment (Step-by-Step, Click-by-Click)

This guide deploys:
- Backend (FastAPI + OpenCV) as a Docker container on AWS App Runner
- Frontend (Vite static site) on S3 + CloudFront

Region used in examples: `us-east-1` (you can pick another, but use the same region everywhere).

---

## 1. Create IAM user for deployment (one-time)

1. Open AWS Console.
2. In search bar, type **IAM** and open it.
3. Left menu -> **Users** -> **Create user**.
4. User name: `parkmate-deployer`.
5. Click **Next**.
6. Choose **Attach policies directly**.
7. Attach these policies:
   - `AmazonEC2ContainerRegistryFullAccess`
   - `AWSAppRunnerFullAccess`
   - `AmazonS3FullAccess`
   - `CloudFrontFullAccess`
8. Click **Next** -> **Create user**.
9. Open the new user -> **Security credentials** tab.
10. Under **Access keys**, click **Create access key**.
11. Use case: **Command Line Interface (CLI)** -> **Next** -> **Create access key**.
12. Save the Access Key ID and Secret Access Key.

---

## 2. Install and configure AWS CLI locally

1. Install AWS CLI v2 from AWS website.
2. Open PowerShell and run:

```powershell
aws configure
```

3. Enter:
   - AWS Access Key ID: your key
   - AWS Secret Access Key: your secret
   - Default region: `us-east-1`
   - Default output format: `json`

4. Verify:

```powershell
aws sts get-caller-identity
```

---

## 3. Create ECR repository for backend image

1. In AWS Console, search **ECR**.
2. Click **Create repository**.
3. Visibility: **Private**.
4. Repository name: `parkmate-backend`.
5. Click **Create repository**.
6. Open repository and copy its URI (looks like `123456789012.dkr.ecr.us-east-1.amazonaws.com/parkmate-backend`).

---

## 4. Build and push backend Docker image

From local machine, run in PowerShell:

```powershell
cd C:\Users\thetr\Downloads\Sayed_sadiq-20260416T212546Z-3-001\Sayed_sadiq\parkmate\backend
```

Set these variables first:

```powershell
$AWS_REGION="us-east-1"
$AWS_ACCOUNT_ID="<your-account-id>"
$ECR_REPO="parkmate-backend"
$IMAGE_TAG="v1"
```

Login Docker to ECR:

```powershell
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
```

Build and push:

```powershell
docker build -t "$ECR_REPO`:$IMAGE_TAG" .
docker tag "$ECR_REPO`:$IMAGE_TAG" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO`:$IMAGE_TAG"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO`:$IMAGE_TAG"
```

---

## 5. Deploy backend on App Runner (console clicks)

1. In AWS Console, search **App Runner**.
2. Click **Create service**.
3. Source and deployment:
   - Source: **Container registry**
   - Provider: **Amazon ECR**
   - Repository: choose `parkmate-backend`
   - Image tag: `v1`
   - Deployment trigger: **Manual** (recommended first time)
4. Click **Next**.
5. Service settings:
   - Service name: `parkmate-backend`
   - Port: `8000`
   - CPU/Memory: start with **1 vCPU / 2 GB**
   - Auto scaling: default is fine
6. Click **Next**.
7. Networking:
   - Egress: **Default**
   - Ingress: **Public access**
8. Click **Next** -> **Create & deploy**.
9. Wait until status is **Running**.
10. Copy the **Default domain URL** (example: `https://xxxx.us-east-1.awsapprunner.com`).
11. Test in browser:
   - `<backend-url>/api/health`
   - `<backend-url>/api/stats`
   - `<backend-url>/video_feed`

---

## 6. Prepare frontend to call AWS backend URL

You must stop using localhost in production.

1. Open file:
   - `parkmate/frontend/src/App.jsx`
2. Change API base line from:

```js
const API_BASE = 'http://127.0.0.1:8000'
```

to:

```js
const API_BASE = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000'
```

3. In `parkmate/frontend`, create `.env.production` with:

```env
VITE_API_BASE=https://<your-apprunner-backend-url>
```

4. Build frontend:

```powershell
cd C:\Users\thetr\Downloads\Sayed_sadiq-20260416T212546Z-3-001\Sayed_sadiq\parkmate\frontend
npm install
npm run build
```

This creates a `dist` folder.

---

## 7. Host frontend on S3 (click-by-click)

1. In AWS Console, search **S3**.
2. Click **Create bucket**.
3. Bucket name: globally unique, for example `parkmate-frontend-yourname-2026`.
4. Region: same region (`us-east-1`).
5. Uncheck **Block all public access**.
6. Acknowledge warning checkbox.
7. Click **Create bucket**.
8. Open the bucket -> **Properties** tab.
9. Scroll to **Static website hosting** -> **Edit**.
10. Enable static website hosting.
11. Index document: `index.html`.
12. Error document: `index.html`.
13. Save changes.
14. Go to **Permissions** tab -> **Bucket policy** -> **Edit**.
15. Paste this policy (replace bucket name):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::parkmate-frontend-yourname-2026/*"
    }
  ]
}
```

16. Save policy.
17. Go to **Objects** tab -> **Upload**.
18. Upload all files inside local `frontend/dist` (not the folder itself).
19. After upload, open the S3 website endpoint from bucket Properties.

---

## 8. Put CloudFront in front of S3 (recommended)

1. In AWS Console, search **CloudFront**.
2. Click **Create distribution**.
3. Origin domain: choose your S3 website endpoint/bucket.
4. Viewer protocol policy: **Redirect HTTP to HTTPS**.
5. Default root object: `index.html`.
6. Click **Create distribution**.
7. Wait for deployment.
8. Open distribution domain name and test app.

If client-side routing breaks on refresh, create a custom error response:
1. Distribution -> **Error pages** -> **Create custom error response**.
2. HTTP error code: `403` and `404`.
3. Customize response: **Yes**.
4. Response page path: `/index.html`.
5. HTTP response code: `200`.

---

## 9. Update backend when you change code

1. Rebuild and push new image tag:

```powershell
cd C:\Users\thetr\Downloads\Sayed_sadiq-20260416T212546Z-3-001\Sayed_sadiq\parkmate\backend
$IMAGE_TAG="v2"
docker build -t "parkmate-backend:$IMAGE_TAG" .
docker tag "parkmate-backend:$IMAGE_TAG" "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/parkmate-backend:$IMAGE_TAG"
docker push "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/parkmate-backend:$IMAGE_TAG"
```

2. In App Runner -> your service -> **Deployments** -> **Deploy new image** -> choose new tag.

---

## 10. Quick validation checklist

- Backend health returns JSON `{"status":"ok"}`.
- Frontend loads over CloudFront URL.
- Home screen stats update every second.
- Live feed shows without broken image icon.
- Browser console has no CORS errors.

---

## Notes for cost control

- Stop/delete unused App Runner services.
- Remove old ECR images.
- Turn off CloudFront distribution if not used.
- Empty and delete S3 bucket when done.
