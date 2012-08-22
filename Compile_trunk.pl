#!/usr/bin/perl -w
# May 31 2006
# Aug 09 2011 ( GCC 4.6.1; Compiler Choice; Compile all source together; TRACC Node Flags - AMD Recommended )

###########################################################
# Usage:
#
#  Compile all regular  : ./Compile.pl
#  Compile one regular  : ./Compile.pl Microsimulator
#
#  Compile all fast     : ./Compile.pl fast
#  Compile one fast     : ./Compile.pl Microsimulator fast
#
#  Compile SysLib fast  : ./Compile.pl syslib
#  Compile SysLib fast  : ./Compile.pl syslib fast
#
###########################################################

#-----------------------------------------------------------------------------------------------------

#-- 64-bit Intel Processor --#

$cc      = "gcc";                                            ## 'pathcc' 'pathCC' 'gcc' 'g++'
$CC      = "g++";                                            ## 'pathcc' 'pathCC' 'gcc' 'g++'
$cflag   = "-D_FILE_OFFSET_BITS=64 -Wall -Wextra -march=amdfam10 -O3 -m64 -pipe -fpic";                                                                  ## $cflag   = "-march=nocona   -O3             -mfpmath=sse -fomit-frame-pointer -D_FILE_OFFSET_BITS=64 -Wall -ansi";
# $cflag   = "-D_FILE_OFFSET_BITS=64 -Wall -Wextra -march=amdfam10 -O3 -m64 -funroll-all-loops -fprefetch-loop-arrays -ftree-parallelize-loops=8";   ## http://developer.amd.com/assets/AMDGCCQuickRef.pdf

# $cc      = "pathcc";                                            ## 'pathcc' 'pathCC' 'gcc' 'g++'
# $CC      = "pathCC";                                            ## 'pathcc' 'pathCC' 'gcc' 'g++'
# $cflag   = "-march=auto -O3 -OPT:ro=2:Olimit=0:div_split=on:alias=typed -fno-math-errno -ffast-math";  ## -Ofast = '-O3 -ipa -OPT:ro=2:Olimit=0:div_split=on:alias=typed -fno-math-errno -ffast-math'
# $cflag   = "-march=auto -Ofast";                                ## PathScale flags

print "\n\tCompiling 64-bit Software for TRACC Nodes\n";

$prog_path     = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/";
$syslib_path   = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/SysLib/";

$include_path  = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/SysLib/Include";
$bin_path      = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/Bin";
$bin_fast_path = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/Bin";
$lib_path      = "/home/sibi/Downloads/Softwares/version5/trunk/src/Transims50/Lib";

$show_cmd       = 1;    #-- 1 = show compilation commands, 0 = hide compilation commands

@syslib_dir = (

	"Data",
	"Dbfile",
	"Files",
	"Path_Builder",
	"Read",
	"Service",
	"Sim_Method",
	"Simulator_IO",
	"Write",
	"Program",
	"Projection",
	"Utility"

);

%prog_dir = (

	ArcNet, 0,
	ArcPlan, 0,
	ArcSnapshot, 0,
	ConvertTrips, 0,
	ExportNet, 0,
	ExportPlans, 0,
	FileFormat, 0,
	IntControl, 0,
	LinkData, 0,
	LinkDelay, 0,
	LinkSum, 0,
	LocationData, 0,
	NetPrep, 0,
	NewFormat, 0,
	PathSkim, 0,
	PlanCompare, 0,
	PlanPrep, 0,
	PlanSelect, 0,
	PlanSum, 0,
	ProblemSelect, 0,
	RandomSelect, 0,
	Relocate, 0,
	Router, 0,
	SimSubareas, 0,
	Simulator, 0,
	TransimsNet, 0,
	TransitDiff, 0,
	TransitNet, 0,
	TripPrep, 0,
	Validate, 0,
);

#-----------------------------------------------------------------------------------------------------

#-- Global Variables --#

my $src_files = undef; 

#-- Arguments --#

if (!$ARGV[0]) {
	$program   = 0;
	$optimized = 0;
}
elsif ($ARGV[0] eq "fast") {
	$program   = 0;
	$optimized = 1;
}
elsif ($ARGV[1]) {
	if ($ARGV[1] eq "fast") {
		$program   = $ARGV[0];
		$optimized = 1;
	}
	else {
		$program   = $ARGV[0];
		$optimized = 0;
	}
}
else {
	$program   = $ARGV[0];
	$optimized = 0;
}

#-- Other Messages --#

if( $optimized == 1) { 	print "\tOptimization    - ON\t$cflag\n"; }
else                 {  print "\tOptimization    - OFF\n"; }

if( $show_cmd == 1) { 	print "\tCommand Display - ON\n"; }
else                 {  print "\tCommand Display - OFF\n"; }

#-- If Compile Only SysLib --#

if ( $program eq "syslib" ) {

	&Compile_Library;
	print "\n\n\tDone!\n";
	exit (0);

}

#--- Step 1: Prepare Library ---

if ($program) {

	$compile_lib = 0;
	my $lib_mod_time;
	my $libfile_mod_time = 0;

	#--- Get Last Modified Library file's time ---

	for ($count = 0; $count <= $#syslib_dir; $count++) {

		$dir = $syslib_path.$syslib_dir[$count];
		$last_mod_file = `ls -rt $dir/*.?pp | tail -1`;
		chomp ($last_mod_file);

		$last_mod_file_time = `stat -t $last_mod_file | gawk '{print \$14}'`;
		chomp ($last_mod_file_time);

		$libfile_mod_time = ($last_mod_file_time > $libfile_mod_time) ? $last_mod_file_time : $libfile_mod_time;
	}

	#--- Get Last Created time for Library ---

	if ($optimized) {
		$lib_file = $lib_path."/"."libSysLib_Fast.a";
	}
	else {
		$lib_file = $lib_path."/"."libSysLib.a";
	}

	if (-e $lib_file) {

		$lib_mod_time = `stat -t $lib_file | gawk '{print \$14}'`;
		chomp ($lib_mod_time);

		#--- If any file modified later, re-compile library ---

		if ($libfile_mod_time >= $lib_mod_time) {
			$compile_lib = 1;
			&Compile_Library;
		}
		else {
			if ($optimized) {
				print "\n\tOptimized SysLib is upto date !\n";
			}
			else {
				print "\n\tRegular SysLib is upto date !\n";
			}
			$compile_lib = 0;
		}
	}
	else {
		$compile_lib = 1;
		&Compile_Library;
	}
}
else {
	$compile_lib = 1;
	&Compile_Library;
}

#--- Step 2: Compile Programs ---

&Compile_Programs ($compile_lib);

#-----------------------------------------------------------------------------------------------------

sub Compile_Library
{
	my $count;
	my $obj_files;
	my $curr_dir = `pwd`;
	chomp ($curr_dir);

	if ($optimized) {
		print "\n\tCompiling Optimized Library ...\n";
	}
	else {
		print "\n\tCompiling Regular Library ...\n";
	}

	for ($count = 0; $count <= $#syslib_dir; $count++) {

		#--- Compile ---

		$dir = $syslib_path.$syslib_dir[$count];
		
		if ($optimized) {
			print "\t\tin $syslib_dir[$count] ... ";
			if( $syslib_dir[$count] eq "Dbfile" ) {
				$src_files = $src_files . " $dir/*.c $dir/*.cpp ";
				if( $cc eq "pathcc" || $cc eq "pathCC" || $CC eq "pathcc" || $CC eq "pathCC" ) {
					$command = "$cc $dir/*.c                             -c $cflag -I $include_path";
					$command = $command . ";" . "$CC  $        dir/*.cpp -c $cflag -I $include_path";
				} else {
					$command = "$cc $dir/*.c                             -c $cflag -I $include_path";
					$command = $command . ";" . "$CC  $        dir/*.cpp -c $cflag -I $include_path";				
				}
			} else {
				$src_files = $src_files . " $dir/*.cpp ";
				$command = "$CC $dir/*.cpp -c $cflag -I $include_path";
			}
			if ( $show_cmd == 1 ) { print "\n$command  ...  "; }
			$exit_stat = system $command;
			system "rm -f $dir/*.o";
			system "mv $curr_dir/*.o $dir/.";
			$obj_files = $obj_files." $dir/*.o";
			if( $exit_stat )    { die   "\n\n\tOptimized SysLib Compilation Failed!\n\n"; }
			else                { print "Ok\n"; }
		}
		else {
			print "\t\tin $syslib_dir[$count] ... ";
			if( $syslib_dir[$count] eq "Dbfile" ) {
				$src_files = $src_files . " $dir/*.c $dir/*.cpp ";
				if( $cc eq "pathcc" || $cc eq "pathCC" || $CC eq "pathcc" || $CC eq "pathCC" ) {
					$command = "$cc $dir/*.c                             -c -I $include_path";
					$command = $command . ";" . "$CC          $dir/*.cpp -c -I $include_path";
				} else {
					$command = "$cc $dir/*.c                             -c -I $include_path";
					$command = $command . ";" . "$CC          $dir/*.cpp -c -I $include_path";				
				}
			} else {
				$src_files = $src_files . " $dir/*.cpp ";
				$command = "$CC $dir/*.cpp -c -I $include_path";
			}
			if ( $show_cmd == 1 ) { print "\n$command  ...  "; }
			$exit_stat = system $command;
			system "rm -f $dir/*.o";
			system "mv $curr_dir/*.o $dir/.";
			$obj_files = $obj_files." $dir/*.o";
			if( $exit_stat )    { die   "\n\n\tRegular SysLib Compilation Failed!\n\n"; }
			else                { print "Ok\n"; }
		}
	}

	#--- Link ---

	print "\n";
	if ($optimized) {
		print "\tCreating Optimized SysLib ... ";
		$command = "ar cr $lib_path"."/"."libSysLib_Fast.a $obj_files";
		$exit_stat = system $command;
		system "rm -f $obj_files";
	}
	else {
		print "\tCreating Regular SysLib ... ";
		$command = "ar cr $lib_path"."/"."libSysLib.a $obj_files";
		$exit_stat = system $command;
		system "rm -f $obj_files";
	}
	if( $exit_stat )    { die   "\n\n\tSysLib Linking Failed!\n\n"; }
	else                { print "Ok\n"; }

}

sub Compile_Programs
{
	my $compile_lib = $_[0];
	my $software;
	my $last_mod_file;
	my $last_mod_file_time;
	my $prog_mod_time;
	my @failed_progs = ();
	my $exit_stat;
	my $count;

	if ($optimized) {
		print "\n\tCompiling Optimized Program(s) ...\n";
	}
	else {
		print "\n\tCompiling Regular Program(s) ...\n";
	}

	$count = 0;
	JOB: for $software (sort keys %prog_dir) {

			#--- Compile ---

			$count++;
			$dir = $prog_path.$software;

			if ($program) {

				if ("$program" ne "$software") {
					next JOB;
				}

				#-- Check program file modification

				$last_mod_file = `ls -rt $dir/*.?pp | tail -1`;
				chomp ($last_mod_file);

				$last_mod_file_time = `stat -t $last_mod_file | gawk '{print \$14}'`;
				chomp ($last_mod_file_time);

				#--- Check binary file modification

				if ($optimized) {
					if (!(-e "$bin_fast_path/$software")) {
						$prog_mod_time = 0;
					}
					else {
						$prog_mod_time = `stat -t $bin_fast_path/$software | gawk '{print \$14}'`;
						chomp ($prog_mod_time);
					}
				}
				else {
					if (!(-e "$bin_path/$software")) {
						$prog_mod_time = 0;
					}
					else {
						$prog_mod_time = `stat -t $bin_path/$software | gawk '{print \$14}'`;
						chomp ($prog_mod_time);
					}
				}

				#--- If file modified later, recompile program

				if ($compile_lib) {
					$prog_mod_time = 0;
				}
				if (!($last_mod_file_time >= $prog_mod_time)) {
					print "\t\t$software is upto date !\n";
					next JOB;
				}
			}

			if ($optimized) {
				print "\t\t$count) $software ...";
				if ($prog_dir{$software}) {
					$command = "$CC $dir/*.cpp $dir/Data/*.cpp -fpic -o $bin_fast_path/$software $cflag -I $include_path -L $lib_path -lSysLib_Fast -lm -lstdc++ -lpthread -lsqlite -ldl";
## test to compile all source files at once					$command = "$CC $src_files $dir/*.cpp $dir/Data/*.cpp -fpic -o $bin_fast_path/$software $cflag -I $include_path -lm -lstdc++ -lpthread -ldl";
				}
				else {
					$command = "$CC $dir/*.cpp -fpic -o $bin_fast_path/$software $cflag -I $include_path -L $lib_path -lSysLib_Fast -lm -lstdc++ -lpthread -lsqlite -ldl";
				}
				if ( $show_cmd == 1 ) { print "\n$command  ...  "; }
				$exit_stat = system $command;
				unless ( $exit_stat ) {
					$version = `$bin_fast_path/$software -n | grep Version | gawk '{ print \$5 }'`;
					chomp ($version);
					print "......\tv$version\n";
				}
			}
			else {
				print "\t\t$count) $software ...";
				if ($prog_dir{$software}) {
					$command = "$CC $dir/*.cpp $dir/Data/*.cpp -fpic -o $bin_path/$software -I $include_path -L $lib_path -lSysLib -lm -lstdc++ -lpthread -lsqlite -ldl";
				}
				else {
					$command = "$CC $dir/*.cpp -fpic -o $bin_path/$software -I $include_path -L $lib_path -lSysLib -lm -lstdc++ -lpthread -lsqlite -ldl";
				}
				if ( $show_cmd == 1 ) { print "\n$command  ...  "; }
				$exit_stat = system $command;
				unless ( $exit_stat ) {
					$version = `$bin_path/$software -n | grep Version | gawk '{ print \$5 }'`;
					chomp ($version);
					print "......\tv$version\n";
				}
			}
			if ($exit_stat) {
				push (@failed_progs, $software);
			}
	}
	if (defined ($failed_progs[0])) {
		$count = 1;
		print "\n\tThe following programs failed to compile:";
		foreach (@failed_progs) {
			print "\n\t$count) $_";
			$count++;
		}
	} else {
		print "\n\tSuccess!";
	}
	print "\n\n";
}
