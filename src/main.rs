use std::process;

fn main() {
    if let Err(e) = roguelike_tutorial::main_loop() {
        eprintln!("Application Error: {e}");
        process::exit(1);
    }
}
