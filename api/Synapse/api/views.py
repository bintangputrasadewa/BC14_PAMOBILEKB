import json
import logging
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.exceptions import ValidationError

# Log setup
logger = logging.getLogger(__name__)

@csrf_exempt
def predict(request):
    """
    Handle the prediction request.
    """
    if request.method == "POST":
        try:
            # Mencoba membaca body dari permintaan POST (mengasumsikan JSON)
            data = json.loads(request.body)
            logger.debug(f"Received data: {data}")
            
            # Validasi data
            if not data.get("feature1") or not data.get("feature2"):
                raise ValidationError("Missing required features")

            # Panggil model atau logika prediksi Anda di sini
            # Misalnya, menggunakan model ML untuk prediksi
            prediction_result = "Prediksi Hasil"

            return JsonResponse({"result": prediction_result}, status=200)

        except json.JSONDecodeError as e:
            # Error dalam decoding JSON
            logger.error(f"Error decoding JSON: {e}")
            return JsonResponse({"error": "Invalid JSON"}, status=400)
        
        except ValidationError as e:
            # Validasi gagal
            logger.error(f"Validation error: {e}")
            return JsonResponse({"error": str(e)}, status=400)
        
        except Exception as e:
            # Error yang tidak terduga
            logger.error(f"Unexpected error: {e}")
            return JsonResponse({"error": "Internal Server Error"}, status=500)

    else:
        # Jika method bukan POST
        return JsonResponse({"error": "Invalid HTTP method"}, status=405)
