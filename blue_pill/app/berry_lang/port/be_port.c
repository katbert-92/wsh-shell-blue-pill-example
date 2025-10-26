#include "be_mem.h"
#include "be_sys.h"
#include "berry.h"
// #include "debug.h"
// #include "fs_wrapper.h"
// #include "mem_wrapper.h"
// #include "time_date.h"
#include <stdio.h>
#include <string.h>

BERRY_API void be_writebuffer(const char* buffer, size_t length) {
    be_fwrite(stdout, buffer, length);
}

BERRY_API char* be_readstring(char* buffer, size_t size) {
    return be_fgets(stdin, buffer, (int)size);
}

void* be_fopen(const char* filename, const char* modes) {
    return fopen(filename, modes);
}

int be_fclose(void* hfile) {
    return fclose(hfile);
}

size_t be_fwrite(void* hfile, const void* buffer, size_t length) {
    return fwrite(buffer, 1, length, hfile);
}

size_t be_fread(void* hfile, void* buffer, size_t length) {
    return fread(buffer, 1, length, hfile);
}

char* be_fgets(void* hfile, void* buffer, int size) {
    return fgets(buffer, size, hfile);
}

int be_fseek(void* hfile, long offset) {
    return fseek(hfile, offset, SEEK_SET);
}

long int be_ftell(void* hfile) {
    return ftell(hfile);
}

long int be_fflush(void* hfile) {
    return fflush(hfile);
}

size_t be_fsize(void* hfile) {
    long int size, offset = be_ftell(hfile);
    fseek(hfile, 0L, SEEK_END);
    size = ftell(hfile);
    fseek(hfile, offset, SEEK_SET);
    return size;
}

// #if BE_USE_FILE_SYSTEM

// void* be_fopen(const char* filename, const char* modes) {
// 	FsWrap_File_t* pFile = (FsWrap_File_t*)MemWrap_Malloc(sizeof(FsWrap_File_t), __FILE__, __LINE__,
// 														  MEM_ALLOC_UNLIM_TMO);
// 	memset(pFile, 0, sizeof(*pFile));
// 	u32 flags = 0;

// 	switch (modes[0]) {
// 		case 'r':
// 			flags |= FS_MODE_READ;
// 			break;
// 		case 'w':
// 			flags |= FS_MODE_CREATE_ALWAYS | FS_MODE_WRITE;
// 			break;
// 		case 'a':
// 			flags |= FS_MODE_APPEND | FS_MODE_WRITE;
// 			break;
// 		default:
// 			return NULL;
// 	}

// 	switch (modes[1]) {
// 		case '+':
// 			flags |= FS_MODE_READ | FS_MODE_WRITE;
// 			break;
// 		case 't':
// 		case 'b':
// 		case '\0':
// 			break;
// 		default:
// 			return NULL;
// 	}

// 	if (modes[1] && modes[2] == '+')
// 		flags |= FS_MODE_READ | FS_MODE_WRITE;

// 	RET_STATE_t res = FsWrap_Open(pFile, filename, flags);
// 	if (res != RET_STATE_SUCCESS)
// 		return NULL;

// 	return pFile;
// }

// int be_fclose(void* hfile) {
// 	RET_STATE_t res = FsWrap_Close((FsWrap_File_t*)hfile);
// 	MemWrap_Free(hfile);

// 	return res != RET_STATE_SUCCESS;
// }

// size_t be_fwrite(void* hfile, const void* buffer, size_t length) {
// 	if (hfile == stdout || hfile == stderr || hfile == stdin) {
// 		return fwrite(buffer, 1, length, hfile);
// 	}

// 	size_t bytesWritten;
// 	RET_STATE_t res = FsWrap_Write((FsWrap_File_t*)hfile, buffer, length, (u32*)&bytesWritten);

// 	return (res == RET_STATE_SUCCESS) ? bytesWritten : 0;
// }

// size_t be_fread(void* hfile, void* buffer, size_t length) {
// 	if (hfile == stdout || hfile == stderr || hfile == stdin) {
// 		return fread(buffer, 1, length, hfile);
// 	}

// 	size_t bytesRead;
// 	RET_STATE_t res = FsWrap_Read((FsWrap_File_t*)hfile, buffer, length, (u32*)&bytesRead);

// 	return res == RET_STATE_SUCCESS ? bytesRead : 0;
// }

// char* be_fgets(void* hfile, void* buffer, int size) {
// 	if (hfile == stdout || hfile == stderr || hfile == stdin) {
// 		return fgets(buffer, size, hfile);
// 	}

// 	return FsWrap_Fgets((FsWrap_File_t*)hfile, (char*)buffer, size);
// }

// int be_fseek(void* hfile, long offset) {
// 	RET_STATE_t res = FsWrap_Seek((FsWrap_File_t*)hfile, offset, FS_SEEK_START);

// 	return res != RET_STATE_SUCCESS;
// }

// long int be_ftell(void* hfile) {
// 	u32 pos;
// 	RET_STATE_t res = FsWrap_Tell((FsWrap_File_t*)hfile, &pos);

// 	if (res == RET_STATE_SUCCESS)
// 		return pos;

// 	return -1;
// }

// long int be_fflush(void* hfile) {
// 	RET_STATE_t res = FsWrap_Sync((FsWrap_File_t*)hfile);

// 	return res != RET_STATE_SUCCESS;
// }

// size_t be_fsize(void* hfile) {
// 	u32 size;
// 	RET_STATE_t res = FsWrap_Size((FsWrap_File_t*)hfile, &size);

// 	if (res == RET_STATE_SUCCESS)
// 		return size;

// 	return (size_t)-1;
// }

// int be_isdir(const char* path) {
// 	FsWrap_DirEnt_t info;
// 	RET_STATE_t res = FsWrap_Stat(path, &info);
// 	if (res == RET_STATE_SUCCESS && info.Type == FS_DIR_ENTRY_DIR)
// 		return true;

// 	return false;
// }

// int be_isfile(const char* path) {
// 	FsWrap_DirEnt_t info;
// 	RET_STATE_t res = FsWrap_Stat(path, &info);
// 	if (res == RET_STATE_SUCCESS && info.Type == FS_DIR_ENTRY_FILE)
// 		return true;

// 	return false;
// }

// int be_isexist(const char* path) {
// 	FsWrap_DirEnt_t info;
// 	RET_STATE_t res = FsWrap_Stat(path, &info);
// 	if (res == RET_STATE_SUCCESS)
// 		return true;

// 	return false;
// }

// char* be_getcwd(char* buf, size_t size) {
// 	RET_STATE_t res = FsWrap_GetCwd(buf, size);
// 	return res == RET_STATE_SUCCESS ? buf : NULL;
// }

// int be_chdir(const char* path) {
// 	RET_STATE_t res = FsWrap_ChDir(path);
// 	return res != RET_STATE_SUCCESS;
// }

// int be_mkdir(const char* path) {
// 	RET_STATE_t res = FsWrap_MkDir(path);

// 	return res != RET_STATE_SUCCESS;
// }

// int be_unlink(const char* filename) {
// 	RET_STATE_t res = FsWrap_Unlink(filename);

// 	return res != RET_STATE_SUCCESS;
// }

// int be_dirfirst(bdirinfo* info, const char* path) {
// 	info->dir  = be_os_malloc(sizeof(FsWrap_Dir_t));
// 	info->file = be_os_malloc(sizeof(FsWrap_DirEnt_t));
// 	if (info->dir && info->file) {
// 		RET_STATE_t res = FsWrap_OpenDir(info->dir, path);
// 		return res == RET_STATE_SUCCESS ? be_dirnext(info) : 1;
// 	}

// 	be_os_free(info->dir);
// 	be_os_free(info->file);
// 	info->dir  = NULL;
// 	info->file = NULL;

// 	return 1;
// }

// int be_dirnext(bdirinfo* info) {
// 	RET_STATE_t res = FsWrap_ReadDir(info->dir, info->file);
// 	info->name		= ((FsWrap_DirEnt_t*)info->file)->Name;

// 	return res != RET_STATE_SUCCESS || *info->name == '\0';
// }

// int be_dirclose(bdirinfo* info) {
// 	if (info->dir) {
// 		RET_STATE_t res = FsWrap_CloseDir(info->dir);

// 		be_os_free(info->dir);
// 		be_os_free(info->file);
// 		return res != RET_STATE_SUCCESS;
// 	}

// 	return 1;
// }

// #endif /* BE_USE_FILE_SYSTEM */

// bint be_time(void) {
// 	return (bint)TimeDate_Timestamp_Get();
// }

// breal be_clock(void) {
// 	return (breal)xTaskGetTickCount() / (breal)1000.0;
// }
