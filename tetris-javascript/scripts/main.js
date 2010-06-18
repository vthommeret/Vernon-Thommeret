var tetris, field, activePiece, context, userPause, newPiece;
var keysDown = {};

var res = 20;
var RIGHT = 0, LEFT = 1;
var INIT_SPEED = 500;

soundManager.flashVersion = 9;

// preload our sounds for scott schill's soundmanager library
soundManager.onload = function() {
    var sounds = ['newGame', 'eraseLines', 'bounce', 'quickMove', 'drop', 'move', 'rotate', 'pause', 'continue', 'newLevel', 'gameOver'];

    for (var i = 0; i < sounds.length; ++i)
        soundManager.createSound({id: sounds[i], url: 'audio/' + sounds[i] + '.mp3', autoLoad: true});

    soundManager.play('newGame');
};

// our main function. this and the gfxcontext object are the only parts
// of the code that interface with the dom. this traps key events and forwards them
// to our tetris object
window.onload = function() {
    var repeatInterval;
    var timers = {};

    window.onkeydown = function(e) {
        var code = e.keyCode;

        switch (code) {
            case 40: // down array
                if ((newPiece || !keysDown[code]) && tetris.down()) {
                    soundManager.play('move');

                    tetris.pause();

                    if (keysDown[code])
                        clearInterval(repeatInterval);
                    
                    repeatInterval = setInterval(function() {
                        if (tetris.down())
                            soundManager.play('move');
                    }, 80);

                    newPiece = false;
                }
            break;
            case 32: // space
                if (!keysDown[code] && tetris.drop()) {
                    soundManager.play('drop');
                    soundManager.play('bounce');
                }
            break;
            case 37: // left
                if ((newPiece || !keysDown[code]) && tetris.left()) {
                    soundManager.play('move');
                    timers[code] = setTimeout(function() {
                        if (tetris.snap(LEFT))
                            soundManager.play('quickMove');
                    }, 200);
                    newPiece = false;
                }
            break;
            case 39: // right
                if ((newPiece || !keysDown[code]) && tetris.right()) {
                    soundManager.play('move');
                    timers[code] = setTimeout(function() {
                        if (tetris.snap(RIGHT))
                            soundManager.play('quickMove');
                    }, 200);
                    newPiece = false;
                }
            break;
            case 90: if (tetris.rotate(LEFT)) soundManager.play('rotate'); break; // z
            case 88: if (tetris.rotate(RIGHT)) soundManager.play('rotate'); break; // x
            case 9: // tab
                if (tetris.paused()) {
                    soundManager.play('continue');
                    tetris.start();
                    userPause = false;
                } else {
                    soundManager.play('pause');
                    tetris.pause();
                    userPause = true;
                }
                return false;
            break;
        }

        keysDown[code] = true;
    }

    window.onkeyup = function(e) {
        var code = e.keyCode;

        if (code == 40) // down
            clearInterval(repeatInterval);

        clearTimeout(timers[code]);
        keysDown[code] = false;

        if (tetris.paused() && !userPause)
            tetris.start();
    }

    tetris = new Tetris();
}

window.onblur = function() {
    // if the user leaves the window and the game isn't already paused, pause it
    if (!tetris.paused()) {
        soundManager.play('pause');
        tetris.pause();
    }
}

window.onfocus = function() {
    // similarly, unpause the game if the user didn't manually initiate the pause
    if (!userPause) {
        soundManager.play('continue');
        tetris.start();
    }
}

// this is our controller and maintains the state of our game. it acts
// as the glue between our activepiece and field object. when a change needs to
// be represented in the interface, context.render() is called
function Tetris() {
    /* instance fields */

    var loop;
    var context;
    var erasedLines = 0;
    var speed = INIT_SPEED;
    var pieces = [
        [[[0,0,0,0],[1,1,1,1],[0,0,0,0],[0,0,0,0]],0,3,'cyan'],
        [[[1,0,0],[1,1,1],[0,0,0]],0,4,'pink'],
        [[[0,0,1],[1,1,1],[0,0,0]],0,4,'blue'],
        [[[1,1],[1,1]],0,4,'red'],
        [[[0,1,1],[1,1,0],[0,0,0]],0,4,'purple'],
        [[[1,1,0],[0,1,1],[0,0,0]],0,4,'yellow'],
        [[[0,1,0],[1,1,1],[0,0,0]],0,4,'green']
    ];

    /* public methods */

    this.start = function(newGame) {
        if (loop != undefined)
            clearInterval(loop);

        loop = setInterval(function() {
            if (!tetris.down()) {
                if (tetris.next()) {
                    newPiece = true;
                } else { // game over
                    clearInterval(loop);
                    loop = null;
                    soundManager.play('gameOver');

                    // start a new game

                    speed = INIT_SPEED;
                    erasedLines = 0;

                    var randomPiece = pieces[Math.floor(Math.random() * pieces.length)];
                    activePiece = new ActivePiece(randomPiece[0],randomPiece[1],randomPiece[2],randomPiece[3]);

                    field.reset();
                    tetris.start();
                }
            }
    
            context.render();
        }, speed);
    }
    this.pause = function() { if (loop != undefined) { clearInterval(loop); loop = null; } };
    this.paused = function() { return loop == undefined; };
    this.next = function() { return transform(); };
    this.down = function() { return transform(1, 0); };
    this.left = function() { return transform(0, -1); };
    this.right = function() { return transform(0, 1); };
    this.rotate = function(rotation) { return transform(0, 0, rotation); };
    this.drop = function() {
        var didDrop = false;
        while (this.down()) didDrop = true;
        this.next();
        this.start();
        return didDrop;
    };
    this.snap = function(direction) {
        var didSnap = false;
        if (direction == LEFT)
            while (this.left()) didSnap = true;
        else
            while (this.right()) didSnap = true;
        return didSnap;
    };

    /* private methods */

    // this function either translates or rotates the active piece
    // it does this by generating a new active piece with the appropriate transformations,
    // and rendering it with the graphics context if it doesn't collide.
    // if no parameters are passed, a new piece is generated, if possible.
    function transform(row, col, rotation) {
        if (row == undefined) {
            erasedLines += field.etchActivePiece();
            var newSpeed = INIT_SPEED - Math.floor(erasedLines / 10) * 50;

            if (newSpeed != speed)
                soundManager.play('newLevel');

            speed = newSpeed;
            
            var randomPiece = pieces[Math.floor(Math.random() * pieces.length)];
            var newActivePiece = new ActivePiece(randomPiece[0],randomPiece[1],randomPiece[2],randomPiece[3]);
        } else {
            var newActivePiece = new ActivePiece(activePiece.getCells(),
                activePiece.getRow() + row, activePiece.getCol() + col, activePiece.getStyle());
    
            if (rotation != undefined)
                newActivePiece.rotate(rotation)
        }

        if (!collides(newActivePiece)) {
            activePiece = newActivePiece;
            context.render();
            return true;
        } else {
            return false;
        }
    }

    // compare an activepiece to the current state of the game and return true if it
    // is within bounds and doesn't collide with any existing blocks
    function collides(activePiece) {
        for (var row = 0; row < activePiece.getHeight(); ++row) {
            for (var col = 0; col < activePiece.getWidth(); ++col) {
                var effectiveRow = row + activePiece.getRow();
                var effectiveCol = col + activePiece.getCol();

                if (activePiece.getCells()[row][col] && ( // cell is shaded
                    effectiveRow < 0 || effectiveRow >= field.getHeight() || // row exceeds bounds
                    effectiveCol < 0 || effectiveCol >= field.getWidth() || // col exceeds bounds
                    field.getCells()[effectiveCol + effectiveRow * field.getWidth()] // collides with field
                )) return true;
            }
        }

        return false;
    }

    /* constructor */

    field = new Field(10,20);

    var randomPiece = pieces[Math.floor(Math.random() * pieces.length)];
    activePiece = new ActivePiece(randomPiece[0],randomPiece[1],randomPiece[2],randomPiece[3]);

    context = new GfxContext();
    context.render();

    this.start();
}

// our field class is responsible for knowing its dimensions and its cells
// and manipulating those cells. it can take an activepiece object and combine (etch)
// it with the current field. if a row is matched, then it erases the row.
function Field(width, height) {
    /* instance fields */

    var cells = [];

    /* public methods */

    this.getCells = function() { return cells; };
    this.getWidth = function() { return width; }
    this.getHeight = function() { return height; }
    this.reset = function() { cells = []; }

    this.etchActivePiece = function() {
        for (var row = 0; row < activePiece.getHeight(); ++row)
            for (var col = 0; col < activePiece.getWidth(); ++col)
                if (activePiece.getCells()[row][col]) // cell is shaded
                    cells[col + activePiece.getCol() + (row + activePiece.getRow()) * width] = 'on ' + activePiece.getStyle();

        // check for completed line

        var erasedLines = 0;

        for (var row = 0; row < height; ++row) {
            var completed = true;

            for (var col = 0; col < width; ++col) {
                if (!cells[col + row * width]) {
                    completed = false;
                    break;
                }
            }

            if (completed) {
                erasedLines++;
                for (var row2 = row; row2 > 0; --row2)
                    for (var col2 = 0; col2 < width; ++col2)
                        cells[col2 + row2 * width] = cells[col2 + (row2 - 1) * width];
            }
        }

        if (erasedLines)
            soundManager.play('eraseLines');
            
        return erasedLines;
    }
}

// it's important to logically treat the currently active piece from the blocks
// in the field. otherwise, the logic might think the active piece is colliding
// with itself
function ActivePiece(cells, row, col, style) {
    /* public methods */

    this.getCells = function() { return cells; };
    this.getRow = function() { return row; };
    this.getCol = function() { return col; };
    this.getWidth = function() { return cells[0].length; };
    this.getHeight = function() { return cells.length; };
    this.getStyle = function() { return style; };

    this.rotate = function(rotation) {
        var rotated = [];

        for (var y = 0; y < cells.length; ++y) {
            rotated[y] = [];
            for (x = 0; x < cells[0].length; ++x)
                rotated[y][x] = rotation ? cells[x][cells.length - y - 1] : cells[cells.length - x - 1][y];
        }

        cells = rotated;
    };

    /* constructor */

    row = row || 0;
    col = col || 0;
}

// the model and the view are kept separate with the graphics context keeping
// them in sync. this and our main method above are the only parts of the code
// that interface with the dom. this is important, because it lets us easily
// swap the interface or environment if needed.
function GfxContext() {
    /* instance fields */

    var fieldView = document.getElementById('field');
    var cellViews = [];
    var width = field.getWidth();
    var height = field.getHeight();

    /* public methods */

    // grab the state from the field and turn on and off the cells in the view respectively
    this.render = function() {
        var fieldCells = field.getCells();

        for (var i = 0; i < width * height; ++i) {
            cellViews[i].className = fieldCells[i];

            if (activePiece) {
                var row = Math.floor(i / width);
                var col = i - (row * width);

                if (col >= activePiece.getCol() && col < activePiece.getCol() + activePiece.getWidth() &&
                    row >= activePiece.getRow() && row < activePiece.getRow() + activePiece.getHeight() &&
                    activePiece.getCells()[row - activePiece.getRow()][col - activePiece.getCol()])
                        cellViews[i].className = 'on ' + activePiece.getStyle();
            }
        }
    }

    /* constructor */

    // set the size of the field
    fieldView.style.width = width * res + 'px';
    fieldView.style.height = height * res + 'px';

    // generate the cells and place them in the field
    for (var i = 0; i < width * height; ++i) {
        cellViews[i] = document.createElement('li');
        cellViews[i].style.width = cellViews[i].style.height = res + 'px';
        fieldView.appendChild(cellViews[i]);
    }
}