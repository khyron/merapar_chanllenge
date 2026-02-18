import json
import boto3
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ssm = boto3.client('ssm')

def lambda_handler(event, context):
    """
    Lambda function handles both REST API and HTTP API formats
    """
    logger.info(f"Event: {json.dumps(event)}")
    
    try:
        # Determine if this is HTTP API v2 or REST API
        is_v2 = "version" in event and event["version"] == "2.0"
        logger.info(f"API Version: {'2.0' if is_v2 else '1.0'}")
        
        # Get parameter name from environment
        parameter_name = os.environ.get('PARAMETER_NAME', '/challenge/dynamic_string')
        
        # Get the dynamic string from SSM
        response = ssm.get_parameter(Name=parameter_name, WithDecryption=False)
        dynamic_string = response['Parameter']['Value']
        
        # Generate HTML
        html_content = f"""<!DOCTYPE html>
<html>
<head>
    <title>Dynamic HTML Page</title>
</head>
<body>
    <h1>The saved string is {dynamic_string}</h1>
</body>
</html>"""
        
        # Base response
        response_body = {
            "statusCode": 200,
            "headers": {
                "Content-Type": "text/html",
                "Access-Control-Allow-Origin": "*"
            },
            "body": html_content
        }
        
        # Add isBase64Encoded for v2
        if is_v2:
            response_body["isBase64Encoded"] = False
            
        return response_body
        
    except Exception as e:
        logger.error(f"Error: {str(e)}", exc_info=True)
        
        error_body = {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json",
                "Access-Control-Allow-Origin": "*"
            },
            "body": json.dumps({"error": "Internal Server Error"})
        }
        
        if "version" in event and event["version"] == "2.0":
            error_body["isBase64Encoded"] = False
            
        return error_body