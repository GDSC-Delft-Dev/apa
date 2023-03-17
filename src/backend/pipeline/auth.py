import firebase_admin
from firebase_admin import credentials
from google.oauth2.service_account import Credentials
import os

def init_firebase() -> None:
    """
    Initializes the firebase connection usign the GCP service 
    account private key from the environment.
    """

    firebase_admin.initialize_app(
        credentials.Certificate({
            "type": "service_account",
            "project_id": "terrafarm-378218",
            "private_key_id": "e49d1713c7e05e739356fc2f9e0759ca2b9dfb8e",
            "private_key": os.environ['GCP_FA_PRIVATE_KEY'].replace(r'\n', '\n'),
            "client_email": "firebase-adminsdk-nept9@terrafarm-378218.iam.gserviceaccount.com",
            "client_id": "101663378253310814844",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/\
                                     firebase-adminsdk-nept9%40terrafarm-378218.iam.gserviceaccount.com"
        })
    )

def get_credentials() -> Credentials:
    """Provides account service credentials."""

    return Credentials.from_service_account_info({
        "type": "service_account",
        "project_id": "terrafarm-378218",
        "private_key_id": "e49d1713c7e05e739356fc2f9e0759ca2b9dfb8e",
        "private_key": os.environ['GCP_FA_PRIVATE_KEY'].replace(r'\n', '\n'),
        "client_email": "firebase-adminsdk-nept9@terrafarm-378218.iam.gserviceaccount.com",
        "client_id": "101663378253310814844",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/\
                                    firebase-adminsdk-nept9%40terrafarm-378218.iam.gserviceaccount.com"
    })
