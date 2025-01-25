import os
from flask import Flask, request
import psycopg2

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST'),
        database=os.getenv('DB_NAME'),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD')
    )
    return conn

@app.route('/', methods=['GET', 'POST'])
def reverse_ip():
    forwarded_for = request.headers.get('X-Forwarded-For', request.remote_addr)
    client_ip = forwarded_for.split(',')[0].strip()
    reversed_ip = ".".join(client_ip.split('.')[::-1])

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('INSERT INTO ip_addresses (ip_address) VALUES (%s)', (reversed_ip,))
    conn.commit()
    conn.close()

    return f"Your reversed public IP is: {reversed_ip}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
