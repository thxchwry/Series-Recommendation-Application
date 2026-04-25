const express = require('express')
const cors = require('cors')
const mysql = require('mysql2')
require('dotenv').config()

const app = express()

app.use(cors())
app.use(express.json())

// สร้างการเชื่อมต่อฐานข้อมูลเพียงครั้งเดียว ใช้ได้กับทุก Route
const connection = mysql.createConnection(process.env.DATABASE_URL)

// หน้าแรกสุด
app.get('/', (req, res) => {
    res.send('รันได้แล้วจร้าาาาาา.')
})

// (/admin)
// ------------------------------------------------------------------------------------------------

app.get('/admin', (req, res) => {
    connection.query(
        'SELECT * FROM admin',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/admin/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM admin WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/admin', (req, res) => {
    connection.query(
        'INSERT INTO `admin` (`fname`, `lname`, `username`, `email`, `phone`, `password`) VALUES (?, ?, ?, ?, ?, ?)',
        [req.body.fname, req.body.lname, req.body.username, req.body.email, req.body.phone, req.body.password],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /admin:', err);
                res.status(500).send('Error adding admin');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/admin', (req, res) => {
    connection.query(
        'UPDATE `admin` SET `fname`=?, `lname`=?, `username`=?, `email`=?, `phone`=?, `password`=? WHERE id =?',
        [req.body.fname, req.body.lname, req.body.username, req.body.email, req.body.phone, req.body.password, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/admin', (req, res) => {
    connection.query(
        'DELETE FROM `admin` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

// (/register)
// ------------------------------------------------------------------------------------------------

app.get('/register', (req, res) => {
    connection.query(
        'SELECT * FROM register',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/register/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM register WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/register', (req, res) => {
    connection.query(
        'INSERT INTO `register` (`fname`, `lname`, `username`, `email`, `phone`, `password`) VALUES (?, ?, ?, ?, ?, ?)',
        [req.body.fname, req.body.lname, req.body.username, req.body.email, req.body.phone, req.body.password],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /admin:', err);
                res.status(500).send('Error adding admin');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/register', (req, res) => {
    connection.query(
        'UPDATE `register` SET `fname`=?, `lname`=?, `username`=?, `email`=?, `phone`=?, `password`=? WHERE id =?',
        [req.body.fname, req.body.lname, req.body.username, req.body.email, req.body.phone, req.body.password, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/register', (req, res) => {
    connection.query(
        'DELETE FROM `register` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

// (/comments)
// ------------------------------------------------------------------------------------------------

app.get('/comments', (req, res) => {
    connection.query(
        'SELECT * FROM comments',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/comments/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM comments WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/comments', (req, res) => {
    connection.query(
        'INSERT INTO `comments` (`username`, `text`, `seriesname`) VALUES (?, ?, ?)',
        [req.body.username, req.body.text, req.body.seriesname],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /admin:', err);
                res.status(500).send('Error adding comment');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/comments', (req, res) => {
    connection.query(
        'UPDATE `comments` SET `username`=?, `text`=?, `seriesname`=? WHERE id =?',
        [req.body.username, req.body.text, req.body.seriesname, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/comments', (req, res) => {
    connection.query(
        'DELETE FROM `comments` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

// (/serieschinese)
// ------------------------------------------------------------------------------------------------

app.get('/serieschinese', (req, res) => {
    connection.query(
        'SELECT * FROM serieschinese',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/serieschinese/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM serieschinese WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/serieschinese', (req, res) => {
    connection.query(
        'INSERT INTO `serieschinese` (`name`, `poster1`, `poster2`, `detail`, `ep`, `application`, `actor`, `actorpicture`, `actress`, `actresspicture`, `support1`, `supportpicture1`, `support2`, `supportpicture2`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /serieschinese:', err);
                res.status(500).send('Error adding series');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/serieschinese', (req, res) => {
    connection.query(
        'UPDATE `serieschinese` SET `name`=?, `poster1`=?, `poster2`=?, `detail`=?, `ep`=?, `application`=?, `actor`=?, `actorpicture`=?, `actress`=?, `actresspicture`=?, `support1`=?, `supportpicture1`=?, `support2`=?, `supportpicture2`=? WHERE id =?',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/serieschinese', (req, res) => {
    connection.query(
        'DELETE FROM `serieschinese` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})


// ==========================================
// 🇰🇷 โซน API สำหรับซีรีส์เกาหลี (/serieskorean)
// ==========================================

app.get('/serieskorean', (req, res) => {
    connection.query(
        'SELECT * FROM serieskorean',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/serieskorean/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM serieskorean WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/serieskorean', (req, res) => {
    connection.query(
        'INSERT INTO `serieskorean` (`name`, `poster1`, `poster2`, `detail`, `ep`, `application`, `actor`, `actorpicture`, `actress`, `actresspicture`, `support1`, `supportpicture1`, `support2`, `supportpicture2`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /serieskorean:', err);
                res.status(500).send('Error adding series');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/serieskorean', (req, res) => {
    connection.query(
        'UPDATE `serieskorean` SET `name`=?, `poster1`=?, `poster2`=?, `detail`=?, `ep`=?, `application`=?, `actor`=?, `actorpicture`=?, `actress`=?, `actresspicture`=?, `support1`=?, `supportpicture1`=?, `support2`=?, `supportpicture2`=? WHERE id =?',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/serieskorean', (req, res) => {
    connection.query(
        'DELETE FROM `serieskorean` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})


// ==========================================
// 🇰🇷 โซน API สำหรับซีรีส์เกาหลี (/serieswestern)
// ==========================================

app.get('/serieswestern', (req, res) => {
    connection.query(
        'SELECT * FROM serieswestern',
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.get('/serieswestern/:id', (req, res) => {
    const id = req.params.id;
    connection.query(
        'SELECT * FROM serieswestern WHERE id = ?', [id],
        function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.post('/serieswestern', (req, res) => {
    connection.query(
        'INSERT INTO `serieswestern` (`name`, `poster1`, `poster2`, `detail`, `ep`, `application`, `actor`, `actorpicture`, `actress`, `actresspicture`, `support1`, `supportpicture1`, `support2`, `supportpicture2`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2],
         function (err, results, fields) {
            if (err) {
                console.error('Error in POST /serieswestern:', err);
                res.status(500).send('Error adding series');
            } else {
                res.status(200).send(results);
            }
        }
    )
})

app.put('/serieswestern', (req, res) => {
    connection.query(
        'UPDATE `serieswestern` SET `name`=?, `poster1`=?, `poster2`=?, `detail`=?, `ep`=?, `application`=?, `actor`=?, `actorpicture`=?, `actress`=?, `actresspicture`=?, `support1`=?, `supportpicture1`=?, `support2`=?, `supportpicture2`=? WHERE id =?',
        [req.body.name, req.body.poster1, req.body.poster2, req.body.detail, req.body.ep, req.body.application, req.body.actor, req.body.actorpicture, req.body.actress, req.body.actresspicture, req.body.support1, req.body.supportpicture1, req.body.support2, req.body.supportpicture2, req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

app.delete('/serieswestern', (req, res) => {
    connection.query(
        'DELETE FROM `serieswestern` WHERE id =?',
        [req.body.id],
         function (err, results, fields) {
            if (err) return res.status(500).send(err);
            res.send(results)
        }
    )
})

// ==========================================
// สั่งรัน Server
// ==========================================
app.listen(process.env.PORT || 3000, () => {
    console.log('✅ CORS-enabled web server listening on port ' + (process.env.PORT || 3000))
})

// export the app for vercel serverless functions
module.exports = app;