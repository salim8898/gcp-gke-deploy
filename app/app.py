import os
from flask import Flask, request
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    conn = mysql.connector.connect(
        host=os.getenv('DB_HOST'),
        database=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        port=3306  # Default MySQL port
    )
    return conn

@app.route('/', methods=['GET', 'POST'])
def reverse_ip():
    forwarded_for = request.headers.get('X-Forwarded-For', request.remote_addr)
    client_ip = forwarded_for.split(',')[0].strip()
    reversed_ip = ".".join(client_ip.split('.')[::-1])

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS reverse_ips (id INT AUTO_INCREMENT PRIMARY KEY, ip_address VARCHAR(255))')
    cursor.execute('INSERT INTO reverse_ips (ip_address) VALUES (%s)', (reversed_ip,))
    conn.commit()
    conn.close()

    return f"Your reversed public IP is: {reversed_ip}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
