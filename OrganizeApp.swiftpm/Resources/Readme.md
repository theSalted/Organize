## CoreML & Pre-compiled Metal Libraray
CoreML and Pre-compiled Metal Library are not fully supported in Swift Playground 4 App. They are the tricky parts of this project. So, just in case if I opened source this or I revist this projects one day. Here is how they works:

### CoreML
Currently Playground couldn't automatically generate class for our CoreML Model. In theory, we could write this class ourself, but a better approach is to copy this generated class from Xcode. Here is how to do this with `MyModelName.mlmodel` as an example:

- Import your .mlmodel to Swift Playground Project. Make sure it appear in the Resources section of the sidebar (and the resources folder of the package).
- Go to Xcode create a new project, and import your .mlmodel. (Doesn't need to be in Resource folder this time)
- Click on `MyModelName.mlmodel`, you should see a little gray line that says "Automatically generated Swift model class" underneath 'Model Class' label
- Jump to definition on `MyModelName` class, you can do this by create an instance of this class in another swift file:
``
let model = try? MobileNetV2FP16(configuration: MLModelConfiguration())
``
and command+click on `MobileNetV2FP16`.
5) In this generated file, copy everything into a new Swift file on your Swift Playground Project. Find `urlOfModelInThisBundle` and replaces it the default implementation with
``
class var urlOfModelInThisBundle : URL {
    let bundle = Bundle(for: self)
    return bundle.url(forResource: "MobileNetV2FP16", withExtension:"mlmodelc")!
}
``
[Reference: Using Core ML in a Swift Playgrounds app](https://marquiskurt.net/post/687335457365868544/using-core-ml-in-a-swift-playgrounds-app)

### CoreML
- Open a new iOS project in Xcode
- Create a new .metal file and write your shaders
- Build the project for your platform
- Press Product > Show Build Folder in Finder, and navigate to Products/Debug-[platform]. For instance, building for Mac Catalyst yields the path Products/Debug-maccatalyst.
- Right-click on your app and choose Show Package Contents , then copy the filedefault.metallib (might be located in the Resources folder)
- Then in Swift Playgrounds. If you have an app: paste the file in the Resources folder of your app (or drag the file into the playgrounds-app). If you have a playground: paste the file in Edits/UserResources of your playground (or choose the file with a file literal)

[Reference: Using Metal in Swift Playground 4](https://betterprogramming.pub/using-metal-in-swift-playgrounds-4-e100122d276a)
