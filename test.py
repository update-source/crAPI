import requests
import json
import time

# ================= CẤU HÌNH =================
# Đường hầm SSH của bạn đang ánh xạ port 8080 về localhost
KEYCLOAK_TOKEN_URL = "http://localhost:8081/realms/crapi-realm/protocol/openid-connect/token"

# IP Public của máy ảo Oracle chứa API Gateway
API_GATEWAY_URL = "http://129.150.33.153:8888/workshop/api/shop/products  "

# Thông tin xác thực (Keycloak Client & User)
AUTH_PAYLOAD = {
    "client_id": "kong-gateway",
    "client_secret": "ANG8v4387J6xg3Hcmu2GRqcwcEwHCa0R",
    "username": "user2",
    "password": "123456",
    "grant_type": "password"
}
# ============================================

def main():
    print("🚀 BẮT ĐẦU QUÁ TRÌNH KIỂM THỬ LUỒNG OAUTH2 + TOKEN EXCHANGE")
    print("-" * 60)
    
    # BƯỚC 1: XIN TOKEN CHUẨN TỪ KEYCLOAK (Token này có chứa 'iss')
    print("[1] Đang xin Token xịn từ Keycloak qua SSH Tunnel...")
    try:
        start_time = time.time()
        token_response = requests.post(KEYCLOAK_TOKEN_URL, data=AUTH_PAYLOAD)
        token_response.raise_for_status()
        
        token_data = token_response.json()
        access_token = token_data.get("access_token")
        
        print(f"  ✅ Lấy Token Keycloak thành công! (Thời gian: {round(time.time() - start_time, 2)}s)")
        
    except requests.exceptions.RequestException as e:
        print("  ❌ Lỗi xin Token từ Keycloak!")
        print(f"  Chi tiết: {e}")
        if 'token_response' in locals():
            print(f"  Phản hồi từ server: {token_response.text}")
        return

    print("-" * 60)

    # BƯỚC 2: MANG TOKEN KEYCLOAK ĐI GỌI API GATEWAY
    # (Kong sẽ nhận Token này, thấy hợp lệ, rồi tự động tráo thành Token crAPI bạn đã cấu hình)
    print(f"[2] Đang gửi Request đến Kong Gateway...")
    print(access_token)
    headers = {
        "Authorization": f"Bearer {access_token}",
        "Content-Type": "application/json"
    }
    
    try:
        start_time = time.time()
        api_response = requests.get(API_GATEWAY_URL, headers=headers)
        
        print(f"  📦 Mã trạng thái HTTP trả về: {api_response.status_code} (Thời gian xử lý: {round(time.time() - start_time, 2)}s)")
        
        if api_response.status_code == 200:
            print("\n🎉 THÀNH CÔNG! KONG ĐÃ DỊCH TOKEN VÀ BACKEND ĐÃ MỞ CỬA.")
            print("Dữ liệu JSON trả về từ crAPI Backend:")
            print(json.dumps(api_response.json(), indent=4, ensure_ascii=False))
        else:
            print("\n⛔ KONG GATEWAY (HOẶC BACKEND) TỪ CHỐI TRUY CẬP.")
            print(f"Lý do: {api_response.text}")
            
    except requests.exceptions.RequestException as e:
        print("  ❌ Lỗi kết nối đến IP Public của Kong Gateway!")
        print(f"  Chi tiết: {e}")

if __name__ == "__main__":
    main()