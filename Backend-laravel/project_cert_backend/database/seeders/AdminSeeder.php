<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Str;
class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $admin=User::create([
            'name'=>'Admin',
            'email'=>'aymen.kammoun@supcom.tn',
            'email_verified_at' => now(),
            'password' => bcrypt('123'),
            'is_admin'=>1,

        ]);
        $token = $admin->createToken('auth_token')->plainTextToken;
    }
}
