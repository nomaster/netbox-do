from os import environ

STORAGE_BACKEND = environ.get('STORAGE_BACKEND', None)
STORAGE_CONFIG = {
    'AWS_ACCESS_KEY_ID': environ.get('AWS_ACCESS_KEY_ID', 'netbox'),
    'AWS_SECRET_ACCESS_KEY': environ.get('AWS_SECRET_ACCESS_KEY', 'netbox'),
    'AWS_STORAGE_BUCKET_NAME': environ.get('AWS_STORAGE_BUCKET_NAME', 'netbox'),
    'AWS_S3_REGION_NAME': environ.get('AWS_S3_REGION_NAME', 'eu-west-1'),
}
