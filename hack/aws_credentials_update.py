#!/usr/bin/env python3

# import sys
import os
import json
import time

home_dir_path: str = os.path.expanduser('~')
aws_dir_path: str = f"{home_dir_path}/.aws"
cache_dir_path: str = f"{aws_dir_path}/login/cache/"

cache_file_path: str = cache_dir_path + os.listdir(cache_dir_path)[0]

cache_json_data = json.load(open(cache_file_path))

new_credentials_file_content: str = (
    f"[default]\n"
    f"aws_access_key_id = {cache_json_data['accessToken']['accessKeyId']}\n"
    f"aws_secret_access_key = {cache_json_data['accessToken']['secretAccessKey']}\n"
    f"aws_session_token = {cache_json_data['accessToken']['sessionToken']}"
)

if os.path.isfile(f"{aws_dir_path}/config"):
    os.remove(f"{aws_dir_path}/config")
if os.path.isfile(f"{aws_dir_path}/credentials"):
    os.remove(f"{aws_dir_path}/credentials")
for cached_credential in os.listdir(cache_dir_path):
    os.remove(cache_dir_path + cached_credential)

credential_file_path: str = f"{home_dir_path}/.aws/credentials"

credentials_file_write_stream = open(credential_file_path, 'w')
credentials_file_write_stream.write(new_credentials_file_content)
credentials_file_write_stream.close()

# # matches time for token expiration
# time.sleep(900)  # 900 seconds = 15 minutes