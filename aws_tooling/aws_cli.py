import sys
import json
import boto3
import argparse


def fetch_images(region, architecture, os, creation_date):
    ec2 = boto3.client("ec2", region_name=region)

    filters = [
        {"Name": "creation-date", "Values": [f"{creation_date}*"]},
        {"Name": "architecture", "Values": [architecture]},
        {"Name": "state", "Values": ["available"]},
        {"Name": "name", "Values": [f"*{os}*"]},
    ]

    try:
        response = ec2.describe_images(Filters=filters)
        return json.dumps(response, indent=4, default=str)
    except Exception as e:
        return print(f"Error: {e}")


def main():
    parser = argparse.ArgumentParser(
        description="Fetch available AWS EC2 AMIs",
        epilog="Example of usage for the script: python3 aws_cli.py --aws_regions eu-west-1 us-east-1 --architecture x86_64 --os ubuntu --creation_date 2023-12-24",
    )
    parser.add_argument(
        "--aws_regions", nargs="+", required=True, help="List of aws regions (e.g., us-east-1 us-west-1)"
    )
    parser.add_argument("--architecture", required=True, help="Architecture (e.g., x86_64)")
    parser.add_argument("--os", required=True, help="Operating System (e.g., ubuntu)")
    parser.add_argument("--creation_date", required=True, help="Date created (e.g., 2023-12-24)")
    args = parser.parse_args()

    for region in args.aws_regions:
        print(f"\033[92m\nFetching for AMIs in region {region}\n\033[0m")
        response = fetch_images(region, args.architecture, args.os, args.creation_date)
        print(response)


if __name__ == "__main__":
    main()
