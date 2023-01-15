<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    public function show()
   {

       $user = auth()->user();
       if ($user){
           return response()->json(['users'=>$user],200);
       }
       else{
           return response()->json(['message'=>' No User Found '],404);
       }
   }
}
