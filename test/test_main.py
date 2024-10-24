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
    req_file = tmp_path / "requirements.txt"
    req_file.write_text("requests==2.31.0\nflask\n")  # Added version number
    
    auto = AutoReq(str(tmp_path))
    
    auto.update_requirements("requests", remove=True)  # Should remove regardless of version
    
    packages = auto._read_requirements()
    assert "requests" not in packages
    assert not any("requests" in pkg for pkg in packages)  # Ensure no version of requests exists
    assert "flask" in packages
