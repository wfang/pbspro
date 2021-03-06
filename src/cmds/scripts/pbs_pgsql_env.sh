#!/bin/false
#
#  Copyright (C) 1994-2016 Altair Engineering, Inc.
#  For more information, contact Altair at www.altair.com.
#   
#  This file is part of the PBS Professional ("PBS Pro") software.
#  
#  Open Source License Information:
#   
#  PBS Pro is free software. You can redistribute it and/or modify it under the
#  terms of the GNU Affero General Public License as published by the Free 
#  Software Foundation, either version 3 of the License, or (at your option) any 
#  later version.
#   
#  PBS Pro is distributed in the hope that it will be useful, but WITHOUT ANY 
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
#  PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.
#   
#  You should have received a copy of the GNU Affero General Public License along 
#  with this program.  If not, see <http://www.gnu.org/licenses/>.
#   
#  Commercial License Information: 
#  
#  The PBS Pro software is licensed under the terms of the GNU Affero General 
#  Public License agreement ("AGPL"), except where a separate commercial license 
#  agreement for PBS Pro version 14 or later has been executed in writing with Altair.
#   
#  Altair’s dual-license business model allows companies, individuals, and 
#  organizations to create proprietary derivative works of PBS Pro and distribute 
#  them - whether embedded or bundled with other software - under a commercial 
#  license agreement.
#  
#  Use of Altair’s trademarks, including but not limited to "PBS™", 
#  "PBS Professional®", and "PBS Pro™" and Altair’s logos is subject to Altair's 
#  trademark licensing policies.

#
# For legacy installations, PostgreSQL was packaged together with PBS.
# If this is a legacy installation, setup the appropiate dynamic
# library paths. Otherwise, set some variables the are used later.
#
PGSQL_LIBSTR=""
if [ -d "$PBS_EXEC/pgsql" ]; then
	# Using PostgreSQL packaged with PBS
	PGSQL_DIR="$PBS_EXEC/pgsql"
	PGSQL_BIN="$PBS_EXEC/pgsql/bin"
	if [ ! -d "$PGSQL_BIN" ]; then
		echo "\*\*\* $PGSQL_BIN directory does not exist"
		exit 1
	fi
	PGSQL_CMD="$PGSQL_BIN/psql"
	if [ ! -x "$PGSQL_CMD" ]; then
		echo "\*\*\* $PGSQL_BIN/psql not executable"
		exit 1
	fi
	case `uname` in
		AIX)
			LIBPATH="$PGSQL_DIR/lib:$LIBPATH"
			export LIBPATH
			PGSQL_LIBSTR="LIBPATH=$LIBPATH; export LIBPATH; "
			;;
		HP-UX)
			SHLIB_PATH="$PGSQL_DIR/lib:$SHLIB_PATH"
			export SHLIB_PATH
			PGSQL_LIBSTR="SHLIB_PATH=$SHLIB_PATH; export SHLIB_PATH; "
			;;
		Linux)
			[ -d "$PGSQL_DIR/lib" ] && LD_LIBRARY_PATH="$PGSQL_DIR/lib:$LD_LIBRARY_PATH"
			[ -d "$PGSQL_DIR/lib64" ] && LD_LIBRARY_PATH="$PGSQL_DIR/lib64:$LD_LIBRARY_PATH"
			export LD_LIBRARY_PATH
			PGSQL_LIBSTR="LD_LIBRARY_PATH=$LD_LIBRARY_PATH; export LD_LIBRARY_PATH; "
			;;
		SunOS)
			LD_LIBRARY_PATH="$PGSQL_DIR/lib:$LD_LIBRARY_PATH"
			LD_LIBRARY_PATH_64="$PGSQL_DIR/lib:$LD_LIBRARY_PATH_64"
			export LD_LIBRARY_PATH LD_LIBRARY_PATH_64
			PGSQL_LIBSTR="LD_LIBRARY_PATH=$LD_LIBRARY_PATH; export LD_LIBRARY_PATH; LD_LIBRARY_PATH_64=$LD_LIBRARY_PATH_64; export LD_LIBRARY_PATH_64; "
			;;
		Darwin)
			DYLD_LIBRARY_PATH="$PGSQL_DIR/lib:$DYLD_LIBRARY_PATH"
			export DYLD_LIBRARY_PATH
			PGSQL_LIBSTR="DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH; export DYLD_LIBRARY_PATH; "
			;;
	esac
else
	# Using system installed PostgreSQL package
	PGSQL_CMD=`type psql 2>/dev/null | cut -d' ' -f3`
	if [ -z "$PGSQL_CMD" ]; then
		echo "\*\*\* psql command is not in PATH"
		exit 1
	fi
	PGSQL_BIN=`dirname $PGSQL_CMD`
	PGSQL_DIR=`dirname $PGSQL_BIN`
	[ "$PGSQL_DIR" = "/" ] && PGSQL_DIR=""
fi

