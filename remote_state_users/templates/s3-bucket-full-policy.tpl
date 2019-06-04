{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "FullAccess",
            "Effect": "Allow",
            "Principal": {
                "AWS": [${full_access_user_arn}]
            },
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${s3_bucket}",
                "arn:aws:s3:::${s3_bucket}/*"
            ]
        }
    ]
}
