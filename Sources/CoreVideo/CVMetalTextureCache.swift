import Foundation
import Metal

public typealias CFAllocator = Any
public typealias CFDictionary = Dictionary <String, Any>

public final class CVMetalTextureCache {
}

@discardableResult
public func CVMetalTextureCacheCreate(_ allocator: CFAllocator?, 
                                      _ cacheAttributes: CFDictionary?, 
                                      _ metalDevice: MTLDevice, 
                                      _ textureAttributes: CFDictionary?, 
                                      _ cacheOut: UnsafeMutablePointer<CVMetalTextureCache?>) -> CVReturn {
    preconditionFailure()
}

public func CVMetalTextureCacheCreateTextureFromImage(_ allocator: CFAllocator?, 
                                                      _ textureCache: CVMetalTextureCache, 
                                                      _ sourceImage: CVImageBuffer, 
                                                      _ textureAttributes: CFDictionary?, 
                                                      _ pixelFormat: MTLPixelFormat, 
                                                      _ width: Int, 
                                                      _ height: Int, 
                                                      _ planeIndex: Int, 
                                                      _ textureOut: UnsafeMutablePointer<CVMetalTexture?>) -> CVReturn {
    preconditionFailure()
}

public func CVMetalTextureCacheFlush(_ textureCache: CVMetalTextureCache, 
                                     _ options: CVOptionFlags) {
    preconditionFailure()
}