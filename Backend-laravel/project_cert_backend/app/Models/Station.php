<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
class Station extends Model
{
    use HasFactory;
    protected $fillable =[
        'name',
        'location',
        'longitude',
        'latitude',
        'state',
    ];
    public function users(){
        return $this->belongsToMany(User::class,'station_user');
    }
}
