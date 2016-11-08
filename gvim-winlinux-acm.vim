set nocompatible
set backspace=indent,eol,start
set cindent
set tabstop=4
set shiftwidth=4
set nu
set nobackup
set noundofile
winpos 200 100
set lines=24 columns=80
func! CompileC()
"windows
	if 0!=has("win32")
		let compileflag=" -g -O2 -std=gnu11 -static % -o %< -lm"
		if 0!=search("gtk/gtk\.h")
			let compileflag=" -g -O2 -std=gnu11 % -o %< -lm"
		endif
		if 0!=search("winsock2.h")
			let compileflag.=" -lws2_32"
		endif
		if 0!=search("gtk/gtk\.h")
			let compileflag.=" -mms-bitfields -ID:/gtk/include/gtk-3.0 -ID:/gtk/include/cairo -ID:/gtk/include/pango-1.0 -ID:/gtk/include/atk-1.0 -ID:/gtk/include/cairo -ID:/gtk/include/pixman-1 -ID:/gtk/include -ID:/gtk/include/freetype2 -ID:/gtk/include -ID:/gtk/include/libpng15 -ID:/gtk/include/gdk-pixbuf-2.0 -ID:/gtk/include/libpng15 -ID:/gtk/include/glib-2.0 -ID:/gtk/lib/glib-2.0/include -LD:/gtk/lib -lgtk-3 -lgdk-3 -lgdi32 -limm32 -lshell32 -lole32 -Wl,-luuid -lpangocairo-1.0 -lpangoft2-1.0 -lfreetype -lfontconfig -lpangowin32-1.0 -lgdi32 -lpango-1.0 -lm -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lintl -mwindows"
		endif
		exec "!gcc".compileflag
	else
"linux
		exec "!gcc -g -O2 -std=gnu11 -static % -o %< -lm"
	endif
endfunc
func! CompileCpp()
	exec "!g++ -g -O2 -std=gnu++14 -static % -o %<"
endfunc
func! CompileJava()
	if 0!==has("win32")
"windows
		exec "!javac -sourcepath . -d . %"
	else
"linux
		exec "!javac -encoding UTF-8 -sourcepath . -d . %"
	endif
endfunc
func! CompilePy()
	exec "!python %"
endfunc
func! CompileCs()
	exec "!dotnet build"
endfunc
func! CompileCode()
	if "c"==&filetype
		exec "call CompileC()"
	elseif "java"==&filetype
		exec "call CompileJava()"
	elseif "cpp"==&filetype
		exec "call CompileCpp()"
	elseif "python"==&filetype
		exec "call CompilePy()"
	elseif "cs"==&filetype
		exec "call CompileCs()"
	endif
endfunc
func! RunResult()
"windows
	if 0!=has("win32")
		if "c"==&filetype
			exec "!cls && %<"
		elseif "cpp"==&filetype
			exec "!cls && %<"
		elseif "java"==&filetype
			exec "!cls && java -XX:+UseSerialGC -Xss8m -Xms128m -Xmx128m %<"
		elseif "python"==&filetype
			exec "!cls && python %"
		endif
	else
"linux
		if "c"==&filetype
			exec "!gnome-terminal -x bash -c \"./%< && read -n1 -p 'Hit any key to close this window...'\""
		elseif "cpp"==&filetype
			exec "!gnome-terminal -x bash -c \"./%< && read -n1 -p 'Hit any key to close this window...'\""
		elseif "java"==&filetype
			exec "!gnome-terminal -x bash -c \"java -XX:+UseSerialGC -Xss8m -Xms128m -Xmx128m %< && read -n1 -p 'Hit any key to close this window...'\""
		elseif "python"==&filetype
			exec "!gnome-terminal -x bash -c \"python % && read -n1 -p 'Hit any key to close this window...'\""
		elseif "cs"==&filetype
			exec "!temp=`basename $PWD` && gnome-terminal -x bash -c \"dotnet ./bin/Debug/netcoreapp1.0/$temp.dll && read -n1 -p 'Hit any key to close this window...'\""
		endif
	endif
endfunc
func! BuildRun()
"windows
	if 0!=has("win32")
		if "c"==&filetype
			let compileflag=" -g -O2 -std=gnu11 -static % -o %< -lm"
			if 0!=search("gtk/gtk\.h")
				let compileflag=" -g -O2 -std=gnu11 % -o %< -lm"
			endif
			if 0!=search("winsock2.h")
				let compileflag.=" -lws2_32"
			endif
			if 0!=search("gtk/gtk\.h")
				let compileflag.=" -mms-bitfields -ID:/gtk/include/gtk-3.0 -ID:/gtk/include/cairo -ID:/gtk/include/pango-1.0 -ID:/gtk/include/atk-1.0 -ID:/gtk/include/cairo -ID:/gtk/include/pixman-1 -ID:/gtk/include -ID:/gtk/include/freetype2 -ID:/gtk/include -ID:/gtk/include/libpng15 -ID:/gtk/include/gdk-pixbuf-2.0 -ID:/gtk/include/libpng15 -ID:/gtk/include/glib-2.0 -ID:/gtk/lib/glib-2.0/include -LD:/gtk/lib -lgtk-3 -lgdk-3 -lgdi32 -limm32 -lshell32 -lole32 -Wl,-luuid -lpangocairo-1.0 -lpangoft2-1.0 -lfreetype -lfontconfig -lpangowin32-1.0 -lgdi32 -lpango-1.0 -lm -latk-1.0 -lcairo-gobject -lcairo -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lglib-2.0 -lintl -mwindows"
			endif
			exec "!gcc".compileflag." && cls && %<"
		elseif "java"==&filetype
			"exec "!javac -encoding UTF-8 -sourcepath . -d . % && cls && java -XX:+UseSerialGC -Xss8m -Xms128m -Xmx128m %<"
			exec "!javac -sourcepath . -d . % && cls && java -XX:+UseSerialGC -Xss8m -Xms128m -Xmx128m %<"
		elseif "cpp"==&filetype
			exec "!g++ -g -O2 -std=gnu++14 -static % -o %< && cls && %<"
		elseif "python"==&filetype
			exec "!cls && python %"
		elseif "javascript"==&filetype
			exec "!cls && node %"
		elseif "go"==&filetype
			exec "!cls && go run %"
		endif
	else
"linux
		if "c"==&filetype
			exec "!gcc -g -O2 -std=gnu11 -static % -o %< -lm && gnome-terminal -x bash -c \"./%< && read -n1 -p 'Hit any key to close this window...'\""
		endif
		if "cpp"==&filetype
			if has("gui_running")
				if 0!=search("GL/glut\.h")
					exec "!g++ -g -O2 -std=gnu++14 % -o %< -lGL -lGLU -lglut && ./%<&"
				elseif 0!=search("gtk/gtk\.h")
					exec "!g++ -g -O2 -std=gnu++14 % -o %< `pkg-config --cflags --libs gtk+-3.0` && ./%<"
				else
					exec "!g++ -g -O2 -std=gnu++14 -static % -o %< && gnome-terminal -x bash -c \"./%< && read -n1 -p 'Hit any key to close this window...'\""
				endif
			else
			if 0!=search("GL/glut\.h")
					exec "!g++ -g -O2 -std=gnu++14 % -o %< -lGL -lGLU -lglut && ./%<&"
				else
					exec "!echo \"g++ -g -O2 -std=gnu++14 -static % -o %< && ./%<\" && g++ -g -O2 -std=gnu++14 -static % -o %< && ./%<"
				endif	
			endif
		endif
		if "java"==&filetype
			exec "!javac -encoding UTF-8 -sourcepath . -d . % && gnome-terminal -x bash -c \"java -XX:+UseSerialGC -Xss8m -Xms128m -Xmx128m %< && echo && read -n1 -p 'Hit any key to close this window...'\""
		endif
		if "python"==&filetype
			exec "!gnome-terminal -x bash -c \"python % && read -n1 -p 'Hit any key to close this window...'\""
		endif
		if "cs"==&filetype
			exec "!temp=`basename $PWD` && dotnet build && gnome-terminal -x bash -c \"dotnet ./bin/Debug/netcoreapp1.0/$temp.dll && read -n1 -p 'Hit any key to close this window...'\""
		endif 
	endif
endfunc
map <F9> :call CompileCode()<CR>
map <F1> :call RunResult()<CR>
map <F5> :call BuildRun()<CR>
