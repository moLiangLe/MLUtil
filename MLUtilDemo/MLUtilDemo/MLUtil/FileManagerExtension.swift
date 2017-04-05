//
//  NSFileManagerExection.swift
//  MLUtilDemo
//
//  Created by moLiang on 2016/10/13.
//  Copyright © 2016年 moliang. All rights reserved.
//

import Foundation


extension FileManager {
    
    lazy var fileManager = FileManager.default
    
    //MARK:沙盒目录相关
    class func homeDir() -> String{
        return NSHomeDirectory()
    }
    
    class func documentsDir() -> String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    class func libraryDir() -> String{
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    }
    
    class func preferencesDir() -> String{
        let libraryDir = "\(self.libraryDir())\\Preferences"
        return libraryDir
    }

    class func cachesDir() -> String{
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }

    class func tmpDir() -> String{
        return NSTemporaryDirectory()
    }
    
    //MARK:遍历文件夹
    class func listFilesInDirectory(atPath:String, byDeep:Bool) -> [String] {
        var listArr:[String] = []
        
        if byDeep {
            do {
                listArr = try FileManager.default.subpathsOfDirectory(atPath: atPath)
            } catch let error {
                print("Error< \(error.localizedDescription) >")
            }
            
        } else {
            do {
                listArr = try FileManager.default.contentsOfDirectory(atPath: atPath)
            } catch let error {
                print("Error< \(error.localizedDescription) >")
            }
        }
        return listArr;
    }
    
    class func listFilesInHomeDirectory(byDeep:Bool) -> [String] {
        return listFilesInDirectory(atPath: self.homeDir(), byDeep: byDeep)
    }
    
    class func listFilesInLibraryDirectory(byDeep:Bool) -> [String] {
        return listFilesInDirectory(atPath: self.documentsDir(), byDeep: byDeep)
    }

    class func listFilesInDocumentDirectory(byDeep:Bool) -> [String] {
        return listFilesInDirectory(atPath: self.tmpDir(), byDeep: byDeep)
    }

    class func listFilesInCachesDirectory(byDeep:Bool) -> [String] {
        return listFilesInDirectory(atPath: self.cachesDir(), byDeep: byDeep)
    }
    
    //MARK:获取文件属性
    class func attributeOfItem(atPath:String, forKey key:String) throws -> Any? {
        do {
            let attributeItem = (try self.attributesOfItem(atPath: atPath) as NSDictionary)[key]
            return attributeItem
        } catch let error  {
            print("Error< \(error.localizedDescription) >")
            throw error
        }
    }
    
    class func attributesOfItem(atPath:String) throws -> [FileAttributeKey : Any] {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: atPath)
            return attributes
        } catch let error {
            throw error
        }
    }
    
    //MARK:根据URL获取文件名
    class func fileName(atPath:String, suffix:Bool) -> String {
        var fileName = (atPath as NSString).lastPathComponent
        if !suffix {
            fileName = (fileName as NSString).deletingPathExtension
        }
        return fileName
    }
    
    class func directory(atPath:String) -> String {
        let directoryString = (atPath as NSString).deletingLastPathComponent
        return directoryString;
    }
    
    class func suffix(atPath:String) -> String {
        let suffixString = (atPath as NSString).pathExtension
        return suffixString;
    }
    
    //MARK:判断文件(夹)是否存在
    class func isExists(atPath:String) -> Bool {
        return FileManager.default.fileExists(atPath: atPath)
    }
    
    
    + (BOOL)isExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    
    + (BOOL)isEmptyItemAtPath:(NSString *)path {
    return [self isEmptyItemAtPath:path error:nil];
    }
    
    + (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self isFileAtPath:path error:error] &&
    [[self sizeOfItemAtPath:path error:error] intValue] == 0) ||
    ([self isDirectoryAtPath:path error:error] &&
    [[self listFilesInDirectoryAtPath:path deep:NO] count] == 0);
    }
    
    + (BOOL)isDirectoryAtPath:(NSString *)path {
    return [self isDirectoryAtPath:path error:nil];
    }
    
    + (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
    }
    
    + (BOOL)isFileAtPath:(NSString *)path {
    return [self isFileAtPath:path error:nil];
    }
    
    + (BOOL)isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeRegular);
    }
    
    + (BOOL)isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
    }
    
    + (BOOL)isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
    }
    + (BOOL)isWritableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
    }
    
    //MARK:创建文件(夹)
    class func createFile(atPath:String, content:NSObject, overwrite:Bool) throws -> Bool {
        let directoryPath = directory(atPath: atPath)
        
    }
    
    + (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 如果文件夹路径不存在，那么先创建文件夹
    NSString *directoryPath = [self directoryAtPath:path];
    if (![self isExistsAtPath:directoryPath]) {
    // 创建文件夹
    if (![self createDirectoryAtPath:directoryPath error:error]) {
    return NO;
    }
    }
    // 如果文件存在，并不想覆盖，那么直接返回YES。
    if (!overwrite) {
    if ([self isExistsAtPath:path]) {
    return YES;
    }
    }
    // 创建文件
    BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    if (content) {
    [self writeFileAtPath:path content:content error:error];
    }
    return isSuccess;
    }
    
    
    + (BOOL)createDirectoryAtPath:(NSString *)path {
    return [self createDirectoryAtPath:path error:nil];
    }
    
    + (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
    }
    
    + (BOOL)createFileAtPath:(NSString *)path {
    return [self createFileAtPath:path content:nil overwrite:YES error:nil];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:YES error:error];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:nil];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:nil overwrite:overwrite error:error];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content {
    return [self createFileAtPath:path content:content overwrite:YES error:nil];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *__autoreleasing *)error {
    return [self createFileAtPath:path content:content overwrite:YES error:error];
    }
    
    + (BOOL)createFileAtPath:(NSString *)path content:(NSObject *)content overwrite:(BOOL)overwrite {
    return [self createFileAtPath:path content:content overwrite:overwrite error:nil];
    }
    
    + (NSDate *)creationDateOfItemAtPath:(NSString *)path {
    return [self creationDateOfItemAtPath:path error:nil];
    }
    
    + (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
    }
    
    + (NSDate *)modificationDateOfItemAtPath:(NSString *)path {
    return [self modificationDateOfItemAtPath:path error:nil];
    }
    
    + (NSDate *)modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileModificationDate error:error];
    }
    
    
}
