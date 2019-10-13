
local keyboard = libs.keyboard;
local script = libs.script;
local sndcard_index = 1;
local last_volume = 0;
local log = libs.log;
local volume_step = 5;

function get_volume()
	log.info(string.format("load soundcard index %d", sndcard_index))
	result = script.shell(string.format("amixer -c %d get Master", sndcard_index));
	volume = tonumber(string.match(result, '(%d+)%%'));
	log.info(string.format("volume %d", volume))
	return volume;
end

function set_volume(value)
	log.info(string.format("set volume to %d%%", volume))
	os.script(string.format("amixer -c %d sset Master %d%%", sndcard_index, math.round(value)));
end

function mute()
	last_volume = get_volume();
	set_volume(0);
end

function unmute()
	set_volume(last_volume);
	last_volume = 0;
end


--@help Lower system volume
actions.volume_down = function()
	volume = get_volume();
	if volume > 0 then
		last_volume = volume;
		set_volume(math.max(0, last_volume - volume_step));
	end
end

--@help Mute system volume
actions.volume_mute = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		mute();
	end
end

--@help Raise system volume
actions.volume_up = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		last_volume = volume;
		set_volume(math.min(100, last_volume + volume_step));
	end
end

--@help Previous track
actions.previous = function()
	keyboard.press("mediaprevious");
end

--@help Next track
actions.next = function()
	keyboard.press("medianext");
end

--@help Stop playback
actions.stop = function()
	keyboard.press("mediastop");
end

--@help Toggle playback state
actions.play_pause = function()
	keyboard.press("mediaplaypause");
end
