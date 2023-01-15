<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Auth\BaseController as BaseController;
use Illuminate\Http\Request;
use App\Models\Station;
use App\Models\StationUser;
use Illuminate\Support\Facades\Auth;

class StationController extends BaseController
{
    //------ Index Stations -----//
    public function index()
    {
        $user = Auth::user();
        $stations = Station::all();
        foreach ($stations as $station) {
            $results = StationUser::where('user_id', '=', $user->id)->where('station_id', '=', $station->id)->get();
            if(count($results)!=0){
                $station['favorite']=1;
            }
            else
            {
                $station['favorite']=0;
            }

        }
        return $this->sendResponse($stations, 'Stations retrieved successfully.');
    }

    //------ show Station -----//
    public function show($id)
    {
        $station = Station::find($id);
        $user = Auth::user();
        if (is_null($station)) {
            return $this->sendError('Station not found.');
        }
        $results = StationUser::where('user_id', '=', $user->id)->where('station_id', '=', $station->id)->get();
        if(count($results)!=0){
            $station['favorite']=1;
        }
        else
        {
            $station['favorite']=0;
        }

        return $this->sendResponse($station, 'Station retrieved successfully.');
    }

    //------update Station -----//
   public function update(Request $request, $id)
   {
        $user = Auth::user();
        if($user->is_admin)
        {
            $station = Station::find($id);
            if ($station){
                $station->update($request->all());
                return $this->sendResponse($station, 'Station updated successfully.');
            }
            else {
                return $this->sendError('No station found!');
            }
        }
        else
        {
            return $this->sendError('You must be admin!');
        }

   }

   public function addFavorite(Request $request,$id)
   {
        $station = Station::find($id);
        $user = Auth::user();
        $results = StationUser::where('user_id', '=', $user->id)->where('station_id', '=', $station->id)->get();
        if(count($results)!=0){
            return $this->sendError('Station already in favorite!');
        }
        $response = StationUser::create([
            "user_id"=>$user->id,
            "station_id"=>$station->id
        ]);

        if($response)
        {
            return $this->sendResponse($response, 'Station added to favorite!');
        }
        else
        {
            return $this->sendError('Error!');
        }
    }

    public function removeFavorite(Request $request,$id)
    {
         $station = Station::find($id);
         $user = Auth::user();
         $result = StationUser::where('user_id', '=', $user->id)->where('station_id', '=', $station->id)->first();
         if($result){
            $result->delete();
            return $this->sendResponse([], 'Station removed from favorite!');
         }
         return $this->sendError('Station is not in favorite!');
     }




    //---------------------  Create Station---------------------//
    public function store(Request $request)
    {
                $request->validate([
                    'name'      => 'required',
                    'location'     => 'required',
                    'longitude'  => 'required',
                    'latitude'  => 'required',

                ]);

                $station = Station::create([
                    'name'      => $request->name,
                    'location'     => $request->location,
                    'longitude'  => $request->longitude,
                    'latitude'     => $request->latitude,
                ]);
                $response = response()->json(['message' => "Station {$station->name} created !"], 200);
        return $response;
    }

   //----- search by name -----//
   public function search($name)
    {
        $response = response()->json(Station::where("name", "like", "%" . $name . "%")->get());
        return $response;
    }




   //------ delete Station-----//
   public function destroy($id)
   {

       $station = Station::find($id);
       if ($station){
           $station->delete();
           return response()->json(['message'=>'Station deleted !'],200);
       }
       else {
           return response()->json(['message'=>' No Station Found '],404);
       }

   }
}
