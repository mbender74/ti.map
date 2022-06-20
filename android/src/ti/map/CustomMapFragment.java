package ti.map;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.google.android.gms.maps.GoogleMapOptions;
import com.google.android.gms.maps.SupportMapFragment;
import org.appcelerator.kroll.common.Log;

public class CustomMapFragment extends SupportMapFragment
{

	private static final String TAG = "CustomMapFragment";

	public CustomMapFragment()
	{
		super();
	}

	public static CustomMapFragment newInstance()
	{
		CustomMapFragment fragment = new CustomMapFragment();
		Log.e(TAG, " newInstance");

		return fragment;
	}

	public static CustomMapFragment newInstance(GoogleMapOptions options)
	{
		Bundle arguments = new Bundle();
		arguments.putParcelable("MapOptions", options);
		CustomMapFragment fragment = new CustomMapFragment();
		fragment.setArguments(arguments);
		Log.e(TAG, " newInstance with options");

		return fragment;
	}

	// @Override
	// public View onCreateView(LayoutInflater arg0, ViewGroup arg1, Bundle arg2) {
	//       Log.e(TAG, " onCreateView");
	//       View v = super.onCreateView(arg0, arg1, arg2);
	//       return v;
	// }
}