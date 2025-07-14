
includes("c")

task("run_main")
    set_menu {
        options = {
            {nil, "file", "v", nil, "test arg"},
        }
    }
    
    on_run(function ()
        import("core.base.task")

        print("Running run_main task...")
        task.run("build", {target="main"})
    end)