// Import and register all your controllers from the importmap under controllers/*

import { application } from "../controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
import StudioController from "../controllers/studio_controller"
import VoxelizerController from "../controllers/voxelizer_controller"
import GUIController from "../controllers/gui_controller"
import CodeController from "../controllers/code_controller"
import AssemblyController from "../controllers/assembly_controller"
import DocsController from "../controllers/docs_controller"
import InspectorController from "../controllers/inspector_controller"
import FeedController from "../controllers/feed_controller"
import LoaderController from "../controllers/loader_controller"


application.register("studio", StudioController)
application.register("code", CodeController)
application.register("voxelizer", VoxelizerController)
application.register("gui", GUIController)
application.register("assembly", AssemblyController)
application.register("docs", DocsController)
application.register("inspector", InspectorController)
application.register("feed", FeedController)
application.register("loader", LoaderController)
