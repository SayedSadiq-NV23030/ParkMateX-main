from pydantic import BaseModel
from typing import List

class SlotStatus(BaseModel):
    id: str
    status: str

class ParkingStats(BaseModel):
    total: int
    occupied: int
    free: int
    occupancy_percent: float
    slots: List[SlotStatus]
