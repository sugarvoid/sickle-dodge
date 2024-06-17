zip -9 -r SickleDodge.love .


: <<'END'
{
	"working_dir": "${project_path:${folder:${file_path}}}",
	"shell_cmd": "love ."
}
END



