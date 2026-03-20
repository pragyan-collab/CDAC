from rest_framework import serializers
from .models import *

class ConsumerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Consumer
        fields = '__all__'

class ServiceCatalogSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceCatalog
        fields = '__all__'

# === ELECTRICITY ===
class ElectricityConsumerSerializer(serializers.ModelSerializer):
    class Meta:
        model = ElectricityConsumer
        fields = '__all__'

class ElectricityBillSerializer(serializers.ModelSerializer):
    class Meta:
        model = ElectricityBill
        fields = '__all__'

class ElectricityPaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = ElectricityPayment
        fields = '__all__'

class ElectricityComplaintSerializer(serializers.ModelSerializer):
    class Meta:
        model = ElectricityComplaint
        fields = '__all__'

class LoadEnhancementRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = LoadEnhancementRequest
        fields = '__all__'

class MeterReplacementRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = MeterReplacementRequest
        fields = '__all__'

class NameTransferRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = NameTransferRequest
        fields = '__all__'

# === GAS ===
class GasConsumerSerializer(serializers.ModelSerializer):
    class Meta:
        model = GasConsumer
        fields = '__all__'

class GasCylinderBookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = GasCylinderBooking
        fields = '__all__'

class GasComplaintSerializer(serializers.ModelSerializer):
    class Meta:
        model = GasComplaint
        fields = '__all__'

class GasSubsidySerializer(serializers.ModelSerializer):
    class Meta:
        model = GasSubsidy
        fields = '__all__'

# === WATER ===
class WaterConsumerSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaterConsumer
        fields = '__all__'

class WaterBillSerializer(serializers.ModelSerializer):
    class Meta:
        model = WaterBill
        fields = '__all__'

# === MUNICIPAL ===
class PropertySerializer(serializers.ModelSerializer):
    class Meta:
        model = Property
        fields = '__all__'

class PropertyTaxSerializer(serializers.ModelSerializer):
    class Meta:
        model = PropertyTax
        fields = '__all__'

class ProfessionalTaxSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProfessionalTax
        fields = '__all__'

class TradeLicenseSerializer(serializers.ModelSerializer):
    class Meta:
        model = TradeLicense
        fields = '__all__'

class BuildingPlanApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuildingPlanApplication
        fields = '__all__'

class GrievanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Grievance
        fields = '__all__'

class BirthCertificateApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = BirthCertificateApplication
        fields = '__all__'

class DeathCertificateApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = DeathCertificateApplication
        fields = '__all__'

class MarriageRegistrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = MarriageRegistration
        fields = '__all__'

# === DOCS, NOTIFS, LOGS ===
class DocumentUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = DocumentUpload
        fields = '__all__'

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = '__all__'

class AuditLogSerializer(serializers.ModelSerializer):
    class Meta:
        model = AuditLog
        fields = '__all__'
