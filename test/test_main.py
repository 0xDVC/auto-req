import pytest
from pathlib import Path
from auto_req.main import AutoReq

def test_should_process_command(monkeypatch):
    auto = AutoReq()
    
    monkeypatch.setattr('sys.argv', ['pip', 'install', 'requests'])
    assert auto._should_process_command() == True
    
    monkeypatch.setattr('sys.argv', ['pip', 'install', '-r', 'requirements.txt'])
    assert auto._should_process_command() == False

def test_is_valid_package():
    auto = AutoReq()
    
    assert auto._is_valid_package('requests') == True
    assert auto._is_valid_package('-r') == False
    assert auto._is_valid_package('git+https://github.com/user/repo.git') == False

def test_update_requirements_remove(tmp_path):
    req_file = Path(tmp_path) / "requirements.txt"  
    req_file.write_text("requests==2.31.0\nflask\n")  
    
    auto = AutoReq(str(tmp_path))
    
    auto.update_requirements("requests", remove=True) 
    
    packages = auto._read_requirements()
    assert "requests" not in packages
    assert not any("requests" in pkg for pkg in packages)
    assert "flask" in packages
    
def test_post_install(monkeypatch, tmp_path):
    req_file = Path(tmp_path) / "requirements.txt" 
    
    existing_packages = {
        'requests': 'requests==2.31.0',
        'flask': 'flask==2.0.1'
    }
    
    req_file.write_text("\n".join(existing_packages.values()) + "\n")
    
    auto = AutoReq(str(tmp_path))
    
    def mock_distributions():
        return [
            type('Distribution', (object,), {'metadata': {'Name': 'requests', 'Version': '2.31.0'}})(),
            type('Distribution', (object,), {'metadata': {'Name': 'flask', 'Version': '2.0.1'}})(),
            type('Distribution', (object,), {'metadata': {'Name': 'auto-req', 'Version': '0.1.0'}})()
        ]
    
    monkeypatch.setattr('importlib.metadata.distributions', mock_distributions)
    
    auto.post_install()
    
    updated_packages = auto._read_requirements()
    
    assert 'requests==2.31.0' in updated_packages
    assert 'flask==2.0.1' in updated_packages
    assert 'auto-req==0.1.0' in updated_packages