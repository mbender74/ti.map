package ti.map;

import android.content.res.AssetFileDescriptor;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import com.google.android.gms.maps.model.Tile;
import com.google.android.gms.maps.model.TileProvider;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileInputStream;
import java.io.IOException;
import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.common.AsyncResult;
import org.appcelerator.kroll.common.Log;
import org.appcelerator.kroll.common.TiMessenger;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.io.TiBaseFile;
import org.appcelerator.titanium.io.TiFileFactory;
import org.appcelerator.titanium.io.TiFileProvider;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.util.TiFileHelper2;
import org.appcelerator.titanium.util.TiRHelper;
import org.appcelerator.titanium.view.TiDrawableReference;

/**
 * Created by stefanlanger on 24.06.14.
 */
public class TilesOfflineTileProvider implements TileProvider
{

	private static final String FILE_FORMAT;
	private static final String DIR_FORMAT;
	private int TILE_WIDTH = 256;
	private int TILE_HEIGHT = 256;
	private static final int BUFFER_SIZE = 16 * 1024;
	String tilesPath;
	String tileExtension;
	TiViewProxy viewproxy;
	int minZoom = 14;
	int maxZoom = 20;

	private static final String TAG = "OfflineTileProvider";
	public static final int MSG_FIRST_ID = 100;
	public static final int MSG_GET_BITMAP = MSG_FIRST_ID + 1;
	public static final int MSG_LAST_ID = MSG_FIRST_ID + 2;

	static
	{
		DIR_FORMAT = "/%d/%d/";
		FILE_FORMAT = "%d";
	}

	public TilesOfflineTileProvider(String path, String extension, int size, TiViewProxy proxy, int minZ, int maxZ)
	{
		tileExtension = FILE_FORMAT + "." + extension;
		tilesPath = path + DIR_FORMAT;
		TILE_WIDTH = size;
		TILE_HEIGHT = size;
		viewproxy = proxy;
		minZoom = minZ;
		maxZoom = maxZ;
	}

	private String getPathToApplicationAsset(String assetName)
	{
		return assetName;
	}

	private boolean checkTileExists(int x, int y, int zoom)
	{
		return (zoom >= minZoom && zoom <= maxZoom);
	}

	/**
     * Fixing tile's y index (reversing order)
     */
	private int fixYCoordinate(int y, int zoom)
	{
		int size = 1 << zoom; // size = 2^zoom
		return size - 1 - y;
	}

	@Override
	public Tile getTile(int x, int y, int zoom)
	{

		if (!checkTileExists(x, y, zoom)) {
			return NO_TILE;
		} else {
			byte[] image = readTileImage(x, y, zoom);
			return image == null ? NO_TILE : new Tile(TILE_WIDTH, TILE_HEIGHT, image);
		}
	}

	private byte[] readTileImage(int x, int y, int zoom)
	{
		String path = getTileFilename(x, y, zoom);
		path.replace("ti.map/", "");

		Bitmap b = TiDrawableReference.fromObject(viewproxy, path).getBitmap(true, false);
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		b.compress(Bitmap.CompressFormat.JPEG, 100, stream);
		b = null;
		return stream.toByteArray();
	}

	private String getTileFilename(int x, int y, int zoom)
	{
		return offlineFolder(zoom, x) + String.format(tileExtension, y);
	}

	private String offlineFolder(int zoom, int x)
	{
		return getPathToApplicationAsset(String.format(tilesPath, zoom, x));
	}
}
