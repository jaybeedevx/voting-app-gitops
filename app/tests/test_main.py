from src.main import app

def test_hello():
    response = app.test_client().get('/')
    assert response.data == b"Voting App - GitOps Ready!"