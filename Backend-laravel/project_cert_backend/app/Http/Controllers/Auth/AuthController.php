<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Controllers\Auth\BaseController as BaseController;
use App\Mail\VerificationMail;
use App\Models\UsersVerify;
use App\Models\UserVerification;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Illuminate\Auth\Events\Registered;

class AuthController extends BaseController
{
    public function register(Request $request)
    {
        $fields=$request->validate(
            ['name'=>'required|string',
            'email'=>'required|string|unique:users',
            'password'=>'required|string',
        ]);
        $user=User::create([
            'name'=>$fields['name'],
            'email'=>$fields['email'],
            'password'=>bcrypt($fields['password']),
            'is_admin' =>  0,

        ]);
        $token = $user->createToken('auth_token')->plainTextToken;

        $result=[
            'name'=>$user->name,
            'email'=>$user->email,
            'token'=>$token,
            'is_admin' =>  $user->is_admin
        ];
        return $this->sendResponse($result, 'User registered successfully.');

    }

    public function login(Request $request)
    {
        $request->validate([
            'email'     => 'email',
            'password'  => 'required',
        ]);

        $user = User::where('email', $request['email'])->first();
        if (!$user || !Hash::check($request['password'], $user->password))

            return $this->sendError('Wrong Input');
        else {
            $token = $user->createToken('auth_token')->plainTextToken;
            $result=[
                'name'=>$user->name,
                'email'=>$user->email,
                'token'=>$token,
                'is_admin' =>  $user->is_admin
            ];
            return $this->sendResponse($result, 'User login successfully.');
        }
    }

    public function sendVerification(Request $request)
    {
        $user = Auth::user();
        $name = $user->name;
        $id = $user->id;
        $to = $user->email;
        $verification=UserVerification::where("user_id", $id)->first();
        if($verification)
        {
            $verification->delete();
        }

        $verification_number = "";
        for($i=0;$i<6;$i++)
        {
            $verification_number.=rand(0,9);
        }

        UserVerification::create([
            'user_id' => $id,
            'verification_number' => $verification_number
        ]);
        $mailData=[
            'user'=>$name,
            'verification_number' =>$verification_number
        ];
        Mail::to($to)->send(new VerificationMail($mailData));
        return $this->sendResponse([], 'Email sent!');
    }

    public function verified(Request $request)
    {
        $user = Auth::user();
        if($user->hasVerifiedEmail())
        {
           return $this->sendResponse(['verified'=>1], 'User is verified!');
        }
        else
        {
            return $this->sendError("user is not verified!",['verified'=>0]);
        }
    }

    public function verify(Request $request)
    {
        $user = Auth::user();
        $verification=UserVerification::where("user_id", $user->id)->first();
        $verification_number = $verification->verification_number;
        //User::ma
        if($request['verification_number']==$verification_number)
        {
            $user->update(["email_verified_at" => now()]);
            $verification->delete();
            //$user->verify();
            return $this->sendResponse([], 'User is verified sucseefully!');
        }
        else{
            return $this->sendError("Wrong number!");
        }
    }

    public function update(Request $request)
    {
        $user = Auth::user();

        # Validation
        $request->validate([
            'old_password' => 'required',
        ]);

        #Match The Old Password
        if(!Hash::check($request->old_password, $user->password)){
            return $this->sendError("Old Password Doesn't match!");
        }

        if($request->new_password&&$request->new_password!="")
        {
            $user->update([
                'name'=>$request->name,
                'email'=>$request->email,
                'password' => Hash::make($request->new_password)
            ]);
        }
        else
        {
            $user->update([
                'name'=>$request->name,
                'email'=>$request->email
            ]);

        }


        return $this->sendResponse($user, 'User updated successfully.');
    }

    public function logout()
    {
        $user = Auth::user();
        $user->tokens()->delete();
        return $this->sendResponse(null, 'User loggedout successfully.');
    }
}
