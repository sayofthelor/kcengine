package;

import sys.FileSystem;
import flixel.system.FlxSound;
import flixel.FlxSprite;
import webm.WebmEvent;
import webm.WebmIoFile;
import webm.WebmPlayer;

/**
 * A extension of `FlxSprite` that can display a video from a .webm file.
 */
class FlxVideo extends FlxSprite
{
	/**
	 * The path to the webm file
	 */
	public var webmPath:String;

	/**
	 * The webm file
	 */
	var io:WebmIoFile;

	/**
	 * The webm player
	 */
	var player:WebmPlayer;

	/**
	 * A variable that gets set to true when the video ends, useful for removing or making events happen once the video has ended
	 */
	public var ended:Bool = false;

	/**
	 * The audio file to go with the video
	 */
	public var audio:FlxSound;

	/**
	 * Create a new `FlxVideo` instance
	 * @param x The x position of the sprite
	 * @param y the y position of the sprite
	 * @param webmPath The path to the webm file
	 * @param autoPlay If the video should play automatically
	 * @param audioPath The path to the audio file that should play with the video
	 */
	public function new(x:Float = 0, y:Float = 0, webmPath:String, autoPlay:Bool = false, ?audioPath:String)
	{
		this.webmPath = webmPath;

		io = new WebmIoFile(webmPath);
		player = new WebmPlayer(io, true);

		player.addEventListener(WebmEvent.PLAY, onPlay);
		player.addEventListener(WebmEvent.STOP, onStop);
		player.addEventListener(WebmEvent.RESTART, onRestart);
		player.addEventListener(WebmEvent.COMPLETE, onComplete);

		if (FileSystem.exists(audioPath) || audioPath != null)
			audio = new FlxSound().loadEmbedded(audioPath);
		else
			trace("Audio path not found/Audio path is null");

		super(x, y, player.bitmapData);

		if (autoPlay)
		{
			if (audio != null)
				audio.play();
			player.play();
		}
	}

	override function destroy()
	{
		@:privateAccess
		player.dispose();
		if (audio != null) {
			audio.destroy();
		}

		super.destroy();
	}

	/**
	 * Called when video playback begins
	 * @param e WebmEvent
	 */
	function onPlay(e:WebmEvent)
	{
		trace("playing");
		ended = false;
	}

	/**
	 * Called when video playback stops
	 * @param e WebmEvent
	 */
	function onStop(e:WebmEvent)
	{
		trace("stopping");
		if (audio != null)
			audio.pause();
		ended = true;
	}

	/**
	 * Called when video playback is restarted
	 * @param e WebmEvent
	 */
	function onRestart(e:WebmEvent)
	{
		trace("restart");
		ended = true;
	}

	/**
	 * Called when the last frame of video has been played
	 * @param e WebmEvent
	 */
	function onComplete(e:WebmEvent)
	{
		trace("complete");
		ended = true;
	}

	/**
	 * Start video playback	
	**/
	public function play()
	{
		player.play();
		if (audio != null && !audio.playing)
			audio.play();
	}

	/**
	 * Stop video playback (todo, after some edits to WebmPlayer?)
	**/
	// public function stop()
	// {
	// 	player.stop();
	// }

	/**
	 * Restart video playback	
	**/
	public function restart()
	{
		player.restart();
		if (audio != null) {
			audio.pause();
			audio.time = 0;
			audio.resume();
		}
	}
}